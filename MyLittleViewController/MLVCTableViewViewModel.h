//
//  MLVCTableViewViewModel.h
//  MyLittleViewController
//
//  Created by derrick on 11/13/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLVCCollectionViewModel.h"

@class MLVCTableViewController;

/**
 You should probably just subclass MLVCCollectionViewModel then implement
 the optional methods in here that you want/need.
 
 @see MLVCCollectionViewModel
 */
@protocol MLVCTableViewViewModel <MLVCCollectionViewModel>
@optional
- (void)tableViewControllerViewDidLoad:(MLVCTableViewController *)tableViewController;
@end

