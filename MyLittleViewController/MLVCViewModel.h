//
//  MLVCViewModel.h
//  MyLittleViewController
//
//  Created by derrick on 11/15/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MLVCViewModel <NSObject>
@optional
- (void)refreshViewModelForced:(BOOL)forced withCompletionBlock:(void (^)())block;

- (void)viewControllerViewDidLoad:(UIViewController *)viewController;
- (void)viewController:(UIViewController *)viewController viewWillAppear:(BOOL)animated;
// add more as needed
@end
