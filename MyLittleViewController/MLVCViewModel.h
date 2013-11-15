//
//  MLVCViewModel.h
//  MyLittleViewController
//
//  Created by derrick on 11/15/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MLVCViewModel <NSObject>
@property (nonatomic) id model;
@property (nonatomic) NSString *name;

@optional
- (void)viewControllerViewDidLoad:(UIViewController *)viewController;
- (void)viewController:(UIViewController *)viewController viewWillAppearAnimated:(BOOL)animated;
// add more as needed
@end

@interface MLVCViewModel : NSObject
@property (nonatomic) id model;
@property (nonatomic) NSString *name;
@end
