//
//  MLVCArrayGroupedCollectionController.m
//  MyLittleViewController
//
//  Created by derrick on 10/2/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import "MLVCCollectionController.h"
#import <UIKit/UIKit.h>

@interface MLVCCollectionControllerGroup ()
- (id)initWithID:(id)groupID title:(NSString *)title;
@property (nonatomic) NSMutableArray *groupedObjects;
@end

@interface MLVCCollectionController ()
@property (nonatomic, copy, readwrite) id (^groupByBlock)(id object);
@property (nonatomic, copy, readwrite) NSString *(^groupTitleBlock)(id object);
@property (nonatomic, copy, readwrite) NSArray *sortDescriptors;
@end

@implementation MLVCCollectionController {
    NSMutableArray *_groups;
    NSMutableDictionary *_groupsByGroupID;
}

- (id)init
{
    self = [super init];
    if (self) {
        _groups = [NSMutableArray array];
        _groupsByGroupID = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (instancetype)collectionControllerGroupingByBlock:(id (^)(id object))groupByBlock groupTitleBlock:(NSString *(^)(id object))groupTitleBlock sortDescriptors:(NSArray *)sortDescriptors
{
    MLVCCollectionController *me = [[self alloc] init];
    
    me.groupByBlock = groupByBlock ?: ^(id object) {
        return (id)@(0);
    };
    me.groupTitleBlock = groupTitleBlock ?: ^(id object) {
        return (NSString *)nil;
    };
    
    NSParameterAssert([sortDescriptors count] > 0);
    me.sortDescriptors = [sortDescriptors copy];
    
    return me;
}


#pragma mark - Querying

- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return self[indexPath.section][indexPath.row];
}

- (id)objectAtIndexedSubscript:(NSUInteger)groupIndex
{
    return self.groups[groupIndex];
}

#pragma mark - inserting and removing

- (MLVCCollectionControllerGroup *)insertGroupForObject:(id)object
{
    MLVCCollectionControllerGroup *group = [[MLVCCollectionControllerGroup alloc] initWithID:self.groupByBlock(object) title:self.groupTitleBlock(object)];
    _groupsByGroupID[group.id] = group;
    
    NSUInteger index = [_groups indexOfObject:group inSortedRange:NSMakeRange(0, [_groups count]) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 id] compare:[obj2 id]];
    }];
    [_groups insertObject:group atIndex:index];

    [self.delegate controller:self didInsertGroup:group atIndex:index];
    return group;
}

- (void)insertObject:(id)object
{
    MLVCCollectionControllerGroup *group = _groupsByGroupID[_groupByBlock(object)];
    if (group == nil) {
        group = [self insertGroupForObject:object];
    }
    NSUInteger objectIndex = [group.objects indexOfObject:object inSortedRange:NSMakeRange(0, group.objects.count) options:NSBinarySearchingInsertionIndex usingComparator:self.comparator];
    [group.groupedObjects insertObject:object atIndex:objectIndex];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:objectIndex inSection:[_groups indexOfObject:group]];
    [self.delegate controller:self didInsertObject:object atIndexPath:indexPath];
}

- (void)insertObjects:(NSArray *)objects
{
    // pre-sorting insures that we don't insert two items at the same index path.
    if (self.sortDescriptors) {
        objects = [objects sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            id groupID1 = self.groupByBlock(obj1);
            id groupID2 = self.groupByBlock(obj2);
            NSComparisonResult groupResult = [groupID1 compare:groupID2];
            if (groupResult != NSOrderedSame) {
                return groupResult;
            }
            
            return self.comparator(obj1, obj2);
        }];
    }
    
    [self.delegate controllerWillChangeContent:self];
    
    for (id object in objects) {
        [self insertObject:object];
    }
    
    [self.delegate controllerDidChangeContent:self];
}

- (NSComparator)comparator
{
    if (!self.sortDescriptors) {
        return nil;
    }
    
    return ^(id left, id right) {
        NSComparisonResult result = NSOrderedSame;
        
        for (NSSortDescriptor *sortDescriptor in self.sortDescriptors) {
            result = [sortDescriptor compareObject:left toObject:right];
            if (result != NSOrderedSame) {
                break;
            }
        }
        
        return result;
    };
}

@end


@implementation MLVCCollectionControllerGroup

- (id)initWithID:(id)groupID title:(NSString *)title
{
    self = [super init];
    if (self) {
        self.groupedObjects = [NSMutableArray array];
        _id = groupID;
        _title = title;
    }
    return self;
}

- (NSArray *)objects {
    return self.groupedObjects;
}

/**
 Subscript access
 */
- (id)objectAtIndexedSubscript:(NSUInteger)itemIndex {
    return self.groupedObjects[itemIndex];
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"%@ \"%@\" [[\n%@\n]]", self.id, self.title, self.groupedObjects];
}

@end