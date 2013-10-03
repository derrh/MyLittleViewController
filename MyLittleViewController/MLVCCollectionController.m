//
//  MLVCArrayGroupedCollectionController.m
//  MyLittleViewController
//
//  Created by derrick on 10/2/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import "MLVCCollectionController.h"

@interface MLVCCollectionControllerGroup ()
@property (nonatomic, readwrite) id group;
@property (nonatomic, readwrite) NSString *groupTitle;
@property (nonatomic) NSRange groupRange;
@property (nonatomic) NSUInteger groupIndex;
@property (nonatomic) NSArray *arrangedObjects;
@end

@interface MLVCCollectionController ()
@property (nonatomic, copy, readwrite) id (^groupByBlock)(id object);
@property (nonatomic, copy, readwrite) NSString *(^groupTitleBlock)(id object);
@property (nonatomic, copy, readwrite) NSArray *sortDescriptors;
@end

@implementation MLVCCollectionController {
    NSMutableArray *_groups;
    NSMutableArray *_arrangedObjects;
    NSMutableDictionary *_groupsByGroupObject;
}

- (id)init
{
    self = [super init];
    if (self) {
        _groups = [NSMutableArray array];
        _arrangedObjects = [NSMutableArray array];
        _groupsByGroupObject = [NSMutableDictionary dictionary];
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
    return self[[indexPath indexAtPosition:0]][[indexPath indexAtPosition:1]];
}

- (id)objectAtIndexedSubscript:(NSUInteger)groupIndex
{
    return self.groups[groupIndex];
}

- (MLVCCollectionControllerGroup *)groupForObject:(id)object {
    id groupObject = self.groupByBlock(object);
    return _groupsByGroupObject[groupObject];
}

#pragma mark - inserting and removing

- (MLVCCollectionControllerGroup *)addGroupForObject:(id)object
{
    MLVCCollectionControllerGroup *group = [MLVCCollectionControllerGroup new];
    group.group = self.groupByBlock(object);
    group.groupTitle = self.groupTitleBlock(object);
    group.groupRange = NSMakeRange([_arrangedObjects count], 0);
    group.groupIndex = [_groups count];
    group.arrangedObjects = self.arrangedObjects;
    [_groups addObject:group];
    _groupsByGroupObject[group.group] = group;
    
#warning delegate callback
//    [self.delegate collectionViewModel:self didInsertSectionAtIndex:section.sectionIndex];
    return group;
}

- (NSIndexPath *)insertObject:(id)object
{
    MLVCCollectionControllerGroup *group = [self groupForObject:object];
    if (!group) {
        group = [self addGroupForObject:object];
    }
    
    NSInteger index = [self indexOfObject:object inGroup:group options:NSBinarySearchingInsertionIndex];
    NSRange range = group.groupRange;
    
    // 1. insert object into arrangedObjects at the correct index
    [_arrangedObjects insertObject:object atIndex:index];
    
    // 2. update the range of the current section
    group.groupRange = NSMakeRange(range.location, range.length + 1);
    
    // 3. update ranges' locations for all sections after current section
    for (NSInteger groupIndex = group.groupIndex + 1; groupIndex < [_groups count]; ++groupIndex) {
        MLVCCollectionControllerGroup *section = _groups[groupIndex];
        NSRange range = section.groupRange;
        ++range.location;
        group.groupRange = range;
    }
    
    NSUInteger path[2] = {group.groupIndex, index - range.location};
    return [NSIndexPath indexPathWithIndexes:path length:2];
}

- (void)insertObjects:(NSArray *)objects
{
    // pre-sorting insures that we don't insert two items at the same index path.
    if (self.sortDescriptors) {
        objects = [objects sortedArrayUsingDescriptors:self.sortDescriptors];
    }
    
#warning delegate callback
//    [self.delegate collectionViewModelDidBeginUpdates:self];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (id object in objects) {
        NSIndexPath *newIndexPath = [self insertObject:object];
        [indexPaths addObject:newIndexPath];
    }
    
#warning  delegate callbacks
//    [self.delegate collectionViewModel:self didInsertItemsAtIndexPaths:indexPaths];
//    
//    [self.delegate collectionViewModelDidEndUpdates:self];
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

- (NSInteger)indexOfObject:(id)object inGroup:(MLVCCollectionControllerGroup *)group options:(NSBinarySearchingOptions)options
{
    NSRange range = group.groupRange;
    NSInteger index = NSNotFound;
    if (self.sortDescriptors) {
        index = [_arrangedObjects indexOfObject:object inSortedRange:range options:options usingComparator:[self comparator]];
    } else {
        index = NSMaxRange(group.groupRange);
    }
    return index;
}

@end


@implementation MLVCCollectionControllerGroup

- (NSArray *)objects
{
    return [self.arrangedObjects subarrayWithRange:self.groupRange];
}

/**
 Subscript access
 */
- (id)objectAtIndexedSubscript:(NSUInteger)itemIndex {
    return self.arrangedObjects[self.groupRange.location + itemIndex];
}

@end