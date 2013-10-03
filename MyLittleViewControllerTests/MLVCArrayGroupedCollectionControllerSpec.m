//
//  MLVCCollectionControllerSpec.m
//  MyLittleViewController
//
//  Created by derrick on 10/2/13.
//  Copyright 2013 Instructure. All rights reserved.
//

#import "Kiwi.h"
#import "MLVCCollectionController.h"
#import <UIKit/UIKit.h>

SPEC_BEGIN(MLVCCollectionControllerSpec)

describe(@"MLVCCollectionController", ^{
   context(@"When created", ^{
       NSString *(^testBlock)(id object) = ^(id object) { return @"Hello, world!"; };
       NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"cats" ascending:YES]];
       MLVCCollectionController *controller = [MLVCCollectionController collectionControllerGroupingByBlock:testBlock groupTitleBlock:testBlock sortDescriptors:sortDescriptors];
       
       it(@"has the right sortDescriptors", ^{
           [[controller.sortDescriptors should] equal:sortDescriptors];
       });
       it(@"has the right groupKeyPath", ^{
           [[controller.groupByBlock should] equal:testBlock];
       });
       it(@"has the right title block", ^{
           [[controller.groupTitleBlock should] equal:testBlock];
       });
       it(@"has a non-nil array of groups", ^{
           [[controller.groups shouldNot] beNil];
       });
       it (@"has an empty array of groups", ^{
           [[theValue(controller.groups.count) should] equal:theValue(0)];
       });
    });
    
    context(@"When created with nil block params", ^{
        NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"cats" ascending:YES]];
        MLVCCollectionController *controller = [MLVCCollectionController collectionControllerGroupingByBlock:nil groupTitleBlock:nil sortDescriptors:sortDescriptors];
        
        it(@"has a non-nil groupByBlock", ^{
            [[controller.groupByBlock shouldNot] beNil];
        });
        it(@"has a non-nil titleBlock", ^{
            [[controller.groupTitleBlock shouldNot] beNil];
        });
    });
    
    context(@"When created with no sort descriptors", ^{
        it(@"throws an exception", ^{
            [[theBlock(^{
                [MLVCCollectionController collectionControllerGroupingByBlock:nil groupTitleBlock:nil sortDescriptors:nil];
            }) should] raise];
            [[theBlock(^{
                [MLVCCollectionController collectionControllerGroupingByBlock:nil groupTitleBlock:nil sortDescriptors:@[]];
            }) should] raise];
        });
    });
    
    
    context(@"When inserting an object", ^{
        MLVCCollectionController *controller = [MLVCCollectionController collectionControllerGroupingByBlock:nil groupTitleBlock:nil sortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"length" ascending:YES]]];
        [controller insertObjects:@[@"aaa"]];
        
        it(@"has only one object", ^{
            [[theValue([controller.arrangedObjects count]) should] equal:theValue(1)];
        });
        it(@"has only one group", ^{
            [[theValue([controller.groups count]) should] equal:theValue(1)];
            [[theValue(controller[0]) shouldNot] beNil];
        });
        it(@"should have @\"aaa\" at [0][0], indexPath 0,0 and arrangedObjects[0]", ^{
            [[controller[0][0] should] equal:@"aaa"];
            [[[controller objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] should] equal:@"aaa"];
            [[controller.arrangedObjects[0] should] equal:@"aaa"];
        });
    });
});

SPEC_END
