//
//  PastriesViewModel.h
//  MyLittleViewController
//
//  Created by derrick on 10/8/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyLittleViewController.h"

@interface PastriesViewModel : NSObject <MLVCCollectionViewModel, MLVCTableViewModel>
@property (nonatomic) MLVCCollectionController *collectionController;
@end
