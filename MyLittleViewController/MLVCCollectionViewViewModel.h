//
//  MLVCCollectionViewViewModel.h
//  MyLittleViewController
//
//  Created by derrick on 11/13/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLVCCollectionViewModel.h"

@class MLVCCollectionViewController;
@protocol MLVCCollectionViewViewModel <MLVCCollectionViewModel>
@optional
- (void)collectionViewControllerViewDidLoad:(MLVCCollectionViewController *)collectionViewController;
@end

