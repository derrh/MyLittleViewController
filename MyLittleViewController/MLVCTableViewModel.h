//
//  MLVCTableViewModel.h
//  MyLittleViewController
//
//  Created by derrick on 11/13/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLVCViewModel.h"

@class MLVCTableViewController;
@protocol MLVCCollectionController;

@protocol MLVCTableViewModel <MLVCViewModel>
@property (nonatomic) id<MLVCCollectionController> collectionController;

@optional
@property (nonatomic, readonly) BOOL allowsMultipleSelectionDuringEditing;
- (void)tableViewControllerViewDidLoad:(MLVCTableViewController *)tableViewController;
@end

