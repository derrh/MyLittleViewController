//
//  MLVCTableViewController.h
//  MyLittleViewController
//
//  Created by derrick on 10/4/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLVCCollectionViewModel.h"

@interface MLVCTableViewController : UITableViewController
@property (nonatomic) IBOutlet MLVCCollectionViewModel *viewModel;
@end
