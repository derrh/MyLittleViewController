//
//  PastriesViewModel.h
//  MyLittleViewController
//
//  Created by derrick on 10/8/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLVCCollectionController.h"

@interface PastriesViewModel : NSObject <MLVCCollectionViewModel, MLVCTableViewModel>
@property (nonatomic) id<MLVCCollectionController> collectionController;
@end
