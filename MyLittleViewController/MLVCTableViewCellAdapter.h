//
//  MLVCTableViewCellAdapter.h
//  MyLittleViewController
//
//  Created by derrick on 10/4/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLVCTableViewController;

@protocol MLVCTableViewCellAdapter <NSObject>
- (UITableViewCell *)tableViewController:(MLVCTableViewController *)controller cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (void)tableViewController:(MLVCTableViewController *)controller didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)tableViewController:(MLVCTableViewController *)controller heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
