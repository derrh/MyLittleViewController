//
//  MLVCCollectionViewModel.h
//  MyLittleViewController
//
//  Created by derrick on 10/8/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLVCCollectionController.h"

@protocol MLVCCollectionViewModel <NSObject>
@property (nonatomic, readonly) MLVCCollectionController *collectionController;

@optional

/**
 @name UITableView support
 */
- (void)tableViewControllerViewDidLoad:(UITableViewController *)tableViewController;
- (void)tableViewController:(UITableViewController *)tableViewController didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 @name UICollectionView support
 */
- (void)collectionViewControllerViewDidLoad:(UICollectionViewController *)collectionViewController;
- (void)collectionViewController:(UICollectionViewController *)controller didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)refreshViewModelWithCompletionBlock:(void (^)())block;
@end

@interface MLVCCollectionViewModel : NSObject <MLVCCollectionViewModel>
@property (nonatomic) MLVCCollectionController *collectionController;
@end
