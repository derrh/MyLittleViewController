//
//  MLVCCollectionViewModel.h
//  MyLittleViewController
//
//  Created by derrick on 10/4/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MLVCCollectionController;
@protocol MLVCCollectionViewModel <NSObject>
@property (nonatomic) MLVCCollectionController *collectionController;
@end

