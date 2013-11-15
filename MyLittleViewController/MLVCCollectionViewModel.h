//
//  MLVCCollectionViewModel.h
//  MyLittleViewController
//
//  Created by derrick on 10/8/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLVCViewModel.h"

@class MLVCCollectionController;

@protocol MLVCCollectionViewModel <MLVCViewModel>
@property (nonatomic) MLVCCollectionController *collectionController;
@optional
- (void)refreshViewModelWithCompletionBlock:(void (^)())block;
@end

@interface MLVCCollectionViewModel : MLVCViewModel <MLVCCollectionViewModel>
@property (nonatomic) MLVCCollectionController *collectionController;
@end
