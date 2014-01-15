//
//  MLVCViewModel.h
//  MyLittleViewController
//
//  Created by derrick on 11/15/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@protocol MLVCViewModel <NSObject>
@optional
- (RACSignal *)refreshViewModelSignalForced:(BOOL)forced;

- (void)viewControllerViewDidLoad:(UIViewController *)viewController;
- (void)viewController:(UIViewController *)viewController viewWillAppear:(BOOL)animated;
// add more as needed
@end
