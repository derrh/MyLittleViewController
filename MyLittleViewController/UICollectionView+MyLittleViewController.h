//
//  UICollectionView+MyLittleViewController.h
//  MyLittleViewController
//
//  Created by derrick on 12/21/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MLVCCollectionController;

@interface UICollectionView (MyLittleViewController)
- (void)mlvc_observeCollectionController:(id<MLVCCollectionController>)collectionController;
@end
