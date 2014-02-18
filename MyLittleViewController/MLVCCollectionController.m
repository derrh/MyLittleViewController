//
//  MLVCArrayGroupedCollectionController.m
//  MyLittleViewController
//
//  Created by derrick on 10/2/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import "MLVCCollectionController.h"
#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "NSObject+RACCollectionChanges.h"
#import <Mantle/EXTScope.h>

@interface MLVCCollectionControllerGroup ()
- (id)initWithID:(id)groupID title:(NSString *)title;
@property (nonatomic) NSUInteger index;
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
    RACSignal *_groupsInsertedIndexSetSignal, *_groupsDeletedIndexSetSignal;
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

#pragma mark - Reacting

- (RACSignal *)groupsInsertedIndexSetSignal
{
    if (_groupsInsertedIndexSetSignal) {
        return _groupsInsertedIndexSetSignal;
    }

    return _groupsInsertedIndexSetSignal = [self rac_filteredIndexSetsForChangeType:NSKeyValueChangeInsertion forCollectionForKeyPath:@"groups"];
}

- (RACSignal *)groupsDeletedIndexSetSignal
{
    if (_groupsDeletedIndexSetSignal) {
        return _groupsDeletedIndexSetSignal;
    }
    
    return _groupsDeletedIndexSetSignal = [self rac_filteredIndexSetsForChangeType:NSKeyValueChangeRemoval forCollectionForKeyPath:@"groups"];
}

- (RACSignal *)signalForIndexPathsOfObjectChangesOfType:(NSKeyValueChange)changeType {
    return [[self groupsInsertedIndexSetSignal] flattenMap:^RACStream *(NSIndexSet *insertedGroups) {
        NSArray *groups = [self.groups objectsAtIndexes:insertedGroups];
        
        NSArray *insertionSignalsForGroups = [[groups.rac_sequence map:^id(MLVCCollectionControllerGroup *group) {
            @weakify(group);
            return [[group rac_filteredIndexSetsForChangeType:changeType forCollectionForKeyPath:@"groupedObjects"] map:^id(NSIndexSet *indexes) {
                @strongify(group);
                NSUInteger groupIndex = group.index;
                return [[indexes.rac_sequence map:^id(NSNumber *index) {
                    return [NSIndexPath indexPathForRow:[index integerValue] inSection:groupIndex];
                }] array];
            }];
        }] array];
        
        return [RACSignal merge:insertionSignalsForGroups];
    }];
}

- (RACSignal *)objectsInsertedIndexPathsSignal {
    return [self signalForIndexPathsOfObjectChangesOfType:NSKeyValueChangeInsertion];
}

- (RACSignal *)objectsDeletedIndexPathsSignal {
    return [self signalForIndexPathsOfObjectChangesOfType:NSKeyValueChangeRemoval];
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
    
    NSMutableArray *mutable = [self mutableArrayValueForKey:@"groups"];
    
    NSUInteger index = [mutable indexOfObject:group inSortedRange:NSMakeRange(0, [_groups count]) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 id] compare:[obj2 id]];
    }];
    group.index = index;
    [mutable insertObject:group atIndex:index];
    for (NSInteger higherIndex = index + 1; higherIndex < [mutable count]; ++higherIndex) {
        MLVCCollectionControllerGroup *laterGroup = mutable[higherIndex];
        laterGroup.index = higherIndex;
    }
    return group;
}

- (void)insertObject:(id)object
{
    MLVCCollectionControllerGroup *group = _groupsByGroupID[_groupByBlock(object)];
    if (group == nil) {
        group = [self insertGroupForObject:object];
    }
    NSMutableArray *mutable = [group mutableArrayValueForKey:@"groupedObjects"];
    NSUInteger objectIndex = [mutable indexOfObject:object inSortedRange:NSMakeRange(0, group.objects.count) options:NSBinarySearchingInsertionIndex usingComparator:self.comparator];
    [mutable insertObject:object atIndex:objectIndex];
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
            
            NSComparisonResult (^comparator)(id, id) = [self comparator];
            return comparator(obj1, obj2);
        }];
    }
    
    for (id object in objects) {
        [self insertObject:object];
    }
}


- (void)removeObjectAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *mutable = [self[indexPath.section] mutableArrayValueForKey:@"groupedObjects"];
    [mutable removeObjectAtIndex:indexPath.row];
}

- (void)removeObjectsAtIndexPaths:(NSArray *)indexPaths
{
    NSMutableIndexSet *indexesToRemoveFromCurrentGroup = nil;
    NSInteger currentGroupIndex = NSNotFound;
    
    NSArray *orderedPaths = [indexPaths sortedArrayUsingSelector:@selector(compare:)];
    for (NSIndexPath *indexPath in orderedPaths) {
        if (currentGroupIndex != indexPath.section) {
            if ([indexesToRemoveFromCurrentGroup count]) {
                [[self[currentGroupIndex] mutableArrayValueForKey:@"groupedObjects"] removeObjectsAtIndexes:indexesToRemoveFromCurrentGroup];
            }
            
            indexesToRemoveFromCurrentGroup = [NSMutableIndexSet indexSet];
            currentGroupIndex = indexPath.section;
        }
        
        [indexesToRemoveFromCurrentGroup addIndex:indexPath.row];
    }
    if ([indexesToRemoveFromCurrentGroup count]) {
        [[self[currentGroupIndex] mutableArrayValueForKey:@"groupedObjects"] removeObjectsAtIndexes:indexesToRemoveFromCurrentGroup];
    }
}

- (void)removeAllObjectsAndGroups
{
    [_groupsByGroupID removeAllObjects];
    NSMutableArray *mutable = [self mutableArrayValueForKey:@"groups"];
    [mutable removeAllObjects];
}

- (void)removeGroupWithGroupID:(id)groupID
{
    NSUInteger index = [[self.groups valueForKey:@"id"] indexOfObject:groupID inSortedRange:NSMakeRange(0, self.groups.count) options:NSBinarySearchingFirstEqual usingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    if (index != NSNotFound) {
        [_groupsByGroupID removeObjectForKey:groupID];
        [[self mutableArrayValueForKey:@"groups"] removeObjectAtIndex:index];
    }
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
