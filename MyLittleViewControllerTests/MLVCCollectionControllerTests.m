//
//  MLVCCollectionControllerTests.m
//  MyLittleViewController
//
//  Created by derrick on 10/17/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MLVCCollectionController.h"
#import "Pastry.h"

@interface MLVCCollectionControllerTests : XCTestCase
@end

@implementation MLVCCollectionControllerTests

- (void)test_creating
{
    NSString *(^testBlock)(id object) = ^(id object) { return @"Hello, world!"; };
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"cats" ascending:YES]];
    MLVCCollectionController *controller = [MLVCCollectionController collectionControllerGroupingByBlock:testBlock groupTitleBlock:testBlock sortDescriptors:sortDescriptors];

    XCTAssertEqual(testBlock, controller.groupByBlock, @"groupByBlock should be set");
    XCTAssertEqual(testBlock, controller.groupTitleBlock, @"groupTitleBlock should equal the test block");
    XCTAssertEqualObjects(sortDescriptors, controller.sortDescriptors, @"Sort descriptors property should be set");
}

- (void)test_creating_with_nil_block_params
{
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"cats" ascending:YES]];
    MLVCCollectionController *controller = [MLVCCollectionController collectionControllerGroupingByBlock:nil groupTitleBlock:nil sortDescriptors:sortDescriptors];
    
    XCTAssertNotNil(controller.groupByBlock, @"a default group by block should be provided");
    XCTAssertNotNil(controller.groupTitleBlock, @"a default title block should be provided");
}

- (void)test_creating_with_no_sort_descriptors
{
    XCTAssertThrows([MLVCCollectionController collectionControllerGroupingByBlock:nil groupTitleBlock:nil sortDescriptors:nil], @"nil sort descriptors array should throw");
    XCTAssertThrows([MLVCCollectionController collectionControllerGroupingByBlock:nil groupTitleBlock:nil sortDescriptors:@[]], @"empty sort descriptors array should throw");
}


- (void)test_inserting_objects_with_no_grouping
{
    MLVCCollectionController *controller = [MLVCCollectionController collectionControllerGroupingByBlock:nil groupTitleBlock:nil sortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"length" ascending:YES]]];
    
    [controller insertObjects:@[@"aaa"]];
    
    int groupCount = [controller.groups count];
    XCTAssertEqual(1, groupCount, @"There should be one group after inserting");
    
    int objectCount = [[controller[0] objects] count];
    XCTAssertEqual(1, objectCount, @"There should be one object in the one group");
    
    XCTAssertEqualObjects(@"aaa", controller[0][0], @"The only object in the collection should be the one we put there");
}


- (void)test_grouping_pastries {
    MLVCCollectionController *controller = [MLVCCollectionController collectionControllerGroupingByBlock:pastryTypeBlock groupTitleBlock:pastryTypeNameBlock sortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"pastryType" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];

    [controller insertObjects:@[[Pastry pastryNamed:@"Glazed Donut" calories:280 type:PastryTypeGlazed],
                                [Pastry pastryNamed:@"Lemon Bar" calories:260 type:PastryTypeLemon]]];
    
    int groupCount = 2;
    XCTAssertEqual(2, groupCount, @"There should be 2 groups");
    XCTAssertEqualObjects(@(PastryTypeLemon), [controller[0] id], @"Lemon pastries are the best. They come first.");
    XCTAssertEqualObjects(@"Lemon", [controller[0] title], @"Group title set properly");
    XCTAssertEqualObjects(@(PastryTypeGlazed), [controller[1] id], @"Glazed come last.");
    XCTAssertEqualObjects(@"Glazed", [controller[1] title], @"Group title set properly");

    [controller insertObjects:@[[Pastry pastryNamed:@"Chocolate Cake Donut" calories:300 type:PastryTypeChocolate]]];

    groupCount = [controller.groups count];
    XCTAssertEqual(3, groupCount, @"There should be 3 groups");
    
    XCTAssertEqualObjects(@(PastryTypeChocolate), [controller[1] id], @"Chocolate pastries come second of course.");
    XCTAssertEqualObjects(@"Chocolate", [controller[1] title], @"Group title set properly");
}

- (void)test_signals_on_insert
{
    __block BOOL groupInserted = NO;
    __block BOOL objectInserted = NO;
    
    MLVCCollectionController *controller = [MLVCCollectionController collectionControllerGroupingByBlock:nil groupTitleBlock:nil sortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"length" ascending:YES]]];
    
    [controller.groupsInsertedIndexSetSignal subscribeNext:^(id x) {
        groupInserted = YES;
    }];
    
    [controller.objectsInsertedIndexPathsSignal subscribeNext:^(id x) {
        objectInserted = YES;
    }];
    
    [controller insertObjects:@[@"foo"]];
    XCTAssert(groupInserted, @"Don't fail me now, ReactiveCocoa");
    XCTAssert(objectInserted, @"We need objects and groups, peeps");
}

@end
