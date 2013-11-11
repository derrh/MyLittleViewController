//
//  MLVCCollectionViewModel.h
//  MyLittleViewController
//
//  Created by derrick on 10/8/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MLVCCollectionController, MLVCTableViewController, MLVCCollectionViewController;

@protocol MLVCCollectionViewModel <NSObject>
@property (nonatomic, readonly) MLVCCollectionController *collectionController;
@optional

/**
 @name UITableView support
 */
- (void)tableViewControllerViewDidLoad:(MLVCTableViewController *)tableViewController;

/**
 @name UICollectionView support
 */
- (void)collectionViewControllerViewDidLoad:(MLVCCollectionViewController *)collectionViewController;

/**
 called on viewWillAppear and pull to refresh
 */
- (void)refreshViewModelWithCompletionBlock:(void (^)())block;
@end

@interface MLVCCollectionViewModel : NSObject <MLVCCollectionViewModel>
@property (nonatomic) MLVCCollectionController *collectionController;
@end
