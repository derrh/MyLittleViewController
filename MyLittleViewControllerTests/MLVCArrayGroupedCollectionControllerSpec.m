//
//  MLVCArrayGroupedCollectionControllerSpec.m
//  MyLittleViewController
//
//  Created by derrick on 10/2/13.
//  Copyright 2013 Instructure. All rights reserved.
//

#import "Kiwi.h"
#import "MLVCArrayGroupedCollectionController.h"

SPEC_BEGIN(MLVCArrayGroupedCollectionControllerSpec)

describe(@"MLVCArrayGroupedCollectionController", ^{
   context(@"When created", ^{
       NSString *(^testBlock)(id object) = ^(id object) { return @"Hello, world!"; };
       NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"cats" ascending:YES]];
       
       MLVCArrayGroupedCollectionController *controller = [MLVCArrayGroupedCollectionController collectionControllerGroupingBy:@"cats.meow" groupTitleBlock:testBlock sortDescriptors:sortDescriptors];
       
       it(@"has the right sortDescriptors", ^{
           [[controller.sortDescriptors should] equal:sortDescriptors];
       });
       it(@"has the right groupKeyPath", ^{
           [[controller.groupKeyPath should] equal:@"cats.meow"];
       });
       it(@"has the right title block", ^{
           [[controller.groupTitleBlock should] equal:testBlock];
       });
       
   });
});

SPEC_END
