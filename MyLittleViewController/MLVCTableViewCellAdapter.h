//
//  MLVCTableViewCellAdapter.h
//  MyLittleViewController
//
//  Created by derrick on 10/4/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MLVCTableViewCellAdapter <NSObject>
- (UITableViewCell *)cellForTableViewController:(UITableViewController *)controller forIndexPath:(NSIndexPath *)indexPath;
@end
