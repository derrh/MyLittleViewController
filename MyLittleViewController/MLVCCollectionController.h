//
//  MLVCCollectionController.h
//  MyLittleViewController
//
//  Created by Derrick Hathaway on 4/23/14.
//  Copyright (c) 2014 Instructure. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <CoreData/CoreData.h>

@protocol MLVCCollectionController <NSObject>

/**
 @name Reacting
 */

@property (nonatomic, readonly) RACSignal *beginUpdatesSignal;

@property (nonatomic, readonly) RACSignal *groupsInsertedIndexSetSignal;

@property (nonatomic, readonly) RACSignal *groupsDeletedIndexSetSignal;

@property (nonatomic, readonly) RACSignal *objectsInsertedIndexPathsSignal;

@property (nonatomic, readonly) RACSignal *objectsDeletedIndexPathsSignal;

@property (nonatomic, readonly) RACSignal *endUpdatesSignal;

/**
 @name Querying
 */
#pragma mark - Querying

/**
 Get the object at a give indexPath.
 
 @param indexPath the indexPath of the given object (supports only section and row)
 @return the object at `indexPath`
 */
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;


/**
 The array of `id<MLVCCollectionControllerGroup>` objects which describe each group
 */
@property (nonatomic, readonly) NSArray *groups;


/**
 Returns the id<MLVCCollectionControllerGroup> at the given subscript
 
 @param groupIndex Index for the group of interest
 */
- (id)objectAtIndexedSubscript:(NSUInteger)groupIndex;


@end


@protocol MLVCCollectionControllerGroup <NSFetchedResultsSectionInfo>

@end