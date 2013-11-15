//
//  MLVCCollectionViewController.h
//  MyLittleViewController
//
//  Created by derrick on 10/18/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLVCCollectionViewViewModel.h"

@interface MLVCCollectionViewController : UICollectionViewController
@property (nonatomic) IBOutlet id <MLVCCollectionViewViewModel> viewModel;
@end
