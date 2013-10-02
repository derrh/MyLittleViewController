//
//  MLVCGroupedCollectionController.h
//  MyLittleViewController
//
//  Created by derrick on 10/2/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol MLVCGroupedCollectionControllerDelegate;
@protocol MLVCGroupedCollectionControllerGroup;

/**
 Manages a grouped and sorted collection of objects.
 
 @discussion `MLVCGroupedCollectionController` manages a collection of objects via a keypath for grouping the objects, and a set of sort descriptors for ordering the collection. It also provides feedback via the
 */
@protocol MLVCGroupedCollectionController <NSObject>

/**
 @name Creating and configuring `MLVCGroupedCollectionController` instances
 */
#pragma mark - object lifecycle

/**
 Constructs an `MLVCGroupedCollectionController` that will group its objects by the `groupKey
 
 @param groupKeyPath The keypath to group objects by. All objects with the same `objectForKeyPath:groupKeyPath` will be ordered in the same group.
 @param groupTitleBlock This method will be called to provide the title for a group on one of the group's objects.
 @param sortDescriptors An array of sort descriptors that will be applied to the collection.
 @return configured instance of `MLVCGroupedCollectionController`
 */
+ (instancetype)collectionControllerGroupingBy:(NSString *)groupKeyPath groupTitleBlock:(NSString *(^)(id object))groupTitleBlock sortDescriptors:(NSArray *)sortDescriptors;

@property (nonatomic, copy, readonly) NSString *groupKeyPath;
@property (nonatomic, copy, readonly) NSString *(^groupTitleBlock)(id object);
@property (nonatomic, copy, readonly) NSArray *sortDescriptors;



@end

@protocol MLVCGroupedCollectionControllerGroup <NSObject>

@end

@protocol MLVCGroupedCollectionControllerDelegate <NSObject>

@end
