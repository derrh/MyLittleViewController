//
//  MLVCTableViewModel.h
//  MyLittleViewController
//
//  Created by derrick on 11/13/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLVCViewModel.h"

@class MLVCTableViewController, MLVCCollectionController;

@protocol MLVCTableViewModel <MLVCViewModel>
@property (nonatomic) MLVCCollectionController *collectionController;

@optional
- (void)tableViewControllerViewDidLoad:(MLVCTableViewController *)tableViewController;
@end

