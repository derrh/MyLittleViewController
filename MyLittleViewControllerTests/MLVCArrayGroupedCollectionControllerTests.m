//
//  MLVCArrayGroupedCollectionControllerTests.m
//  MyLittleViewController
//
//  Created by derrick on 10/2/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MLVCArrayGroupedCollectionController.h"

@interface MLVCArrayGroupedCollectionControllerTests : XCTestCase

@end

@implementation MLVCArrayGroupedCollectionControllerTests

- (void)test_construction {
    NSString *(^testBlock)(id object) = ^(id object) {
        return @"Hello, world!";
    };
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"cats" ascending:YES]];
    
    MLVCArrayGroupedCollectionController *controller = [MLVCArrayGroupedCollectionController collectionControllerGroupingBy:@"cats.meow" groupTitleBlock:testBlock sortDescriptors:sortDescriptors];
    
    XCTAssertEqualObjects(@"cats.meow", controller.groupKeyPath, @"groupKeyPath doesn't match construction parameter");
    XCTAssertEqualObjects(sortDescriptors, controller.sortDescriptors, @"sortDescriptors property does not match sort descriptors from construction");
    XCTAssertEqualObjects(testBlock, controller.groupTitleBlock, @"groupTitle block does not match value passed in during construction");
}

@end
