//
//  MLVCViewController.m
//  MyLittleViewController
//
//  Created by derrick on 11/15/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import "MLVCViewController.h"

@implementation MLVCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.viewModel respondsToSelector:@selector(viewControllerViewDidLoad:)]) {
        [self.viewModel viewControllerViewDidLoad:self];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.viewModel respondsToSelector:@selector(viewController:viewWillAppearAnimated:)]) {
        [self.viewModel viewController:self viewWillAppearAnimated:animated];
    }
}
@end
