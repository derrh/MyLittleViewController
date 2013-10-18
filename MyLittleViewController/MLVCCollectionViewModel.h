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
- (void)cellSelectedAtIndexPath:(NSIndexPath *)indexPath inController:(UITableViewController *)controller;

@optional
- (void)viewDidLoadForController:(UITableViewController *)controller;
- (void)refreshViewModelWithCompletionBlock:(void (^)())block;
@end

@interface MLVCCollectionViewModel : NSObject <MLVCCollectionViewModel>
@property (nonatomic) MLVCCollectionController *collectionController;
@end
