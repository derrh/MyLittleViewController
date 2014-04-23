//
//  PastriesViewModel.m
//  MyLittleViewController
//
//  Created by derrick on 10/8/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import "PastriesViewModel.h"
#import "MLVCManualCollectionController.h"
#import "Pastry.h"

@implementation PastriesViewModel

- (id)init
{
    self = [super init];
    if (self) {
        self.collectionController = [MLVCManualCollectionController collectionControllerGroupingByBlock:pastryTypeBlock groupTitleBlock:pastryTypeNameBlock sortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    }
    return self;
}

- (void)refreshViewModelForced:(BOOL)forced withCompletionBlock:(void (^)())block
{
    
}

@end
