//
//  MLVCCollectionViewModel.h
//  MyLittleViewController
//
//  Created by derrick on 11/13/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLVCViewModel.h"

@class MLVCCollectionViewController;
@protocol MLVCCollectionController;

@protocol MLVCCollectionViewModel <MLVCViewModel>
@property (nonatomic) id<MLVCCollectionController> collectionController;

@optional
- (void)collectionViewControllerViewDidLoad:(MLVCCollectionViewController *)collectionViewController;

- (UICollectionReusableView *)collectionViewController:(UICollectionViewController *)controller viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;
@end

