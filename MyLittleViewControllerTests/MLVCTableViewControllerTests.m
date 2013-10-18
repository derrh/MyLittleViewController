//
//  MLVCTableViewControllerTests.m
//  MyLittleViewController
//
//  Created by derrick on 10/17/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "MLVCTableViewController.h"
#import "PastriesViewModel.h"
#import "Pastry.h"
#import "Pastry+TableViewAdapter.h"
#import "PastriesViewModel.h"

@interface MLVCTableViewControllerTests : XCTestCase
@property (nonatomic) id mockViewModel;
@property (nonatomic) id mockGroupsArray;
@property (nonatomic) id mockCollectionController;

@property (nonatomic) MLVCTableViewController *controller;
@end

@implementation MLVCTableViewControllerTests

- (void)setUp {
    [super setUp];
    self.mockViewModel = [OCMockObject niceMockForClass:[PastriesViewModel class]];
    self.mockGroupsArray = [OCMockObject niceMockForClass:[NSArray class]];
    self.mockCollectionController = [OCMockObject niceMockForClass:[MLVCCollectionController class]];

    [[[self.mockViewModel stub] andReturn:self.mockCollectionController] collectionController];
    [[[self.mockCollectionController stub] andReturn:self.mockGroupsArray] groups];
    
    self.controller = [MLVCTableViewController new];
}

- (void)tearDown {
    [super tearDown];
    self.mockViewModel = nil;
    self.mockGroupsArray = nil;
    self.mockCollectionController = nil;
}

- (void)test_set_view_model
{
    id mockGroupsInsertedSignal = [OCMockObject niceMockForClass:[RACSignal class]];
    [[[self.mockCollectionController stub] andReturn:mockGroupsInsertedSignal] groupsInsertedIndexSetSignal];
    [[mockGroupsInsertedSignal expect] subscribeNext:OCMOCK_ANY];
    
    id mockObjectsInsertedSignal = [OCMockObject niceMockForClass:[RACSignal class]];
    [[[self.mockCollectionController stub] andReturn:mockObjectsInsertedSignal] objectsInsertedIndexPathsSignal];
    [[mockObjectsInsertedSignal expect] subscribeNext:OCMOCK_ANY];
    
    self.controller.viewModel = self.mockViewModel;
    XCTAssertEqual(self.mockViewModel, self.controller.viewModel, @"View model is set");
    [mockObjectsInsertedSignal verify];
    [mockGroupsInsertedSignal verify];
}

- (void)test_refreshes
{
    MLVCTableViewController *pastryController = [MLVCTableViewController new];
    pastryController.viewModel = [OCMockObject partialMockForObject:[PastriesViewModel new]];
    XCTAssertNotNil(pastryController.refreshControl, @"refresh controll should not be nil");
    
    [[(id)(pastryController.viewModel) expect] refreshViewModelWithCompletionBlock:OCMOCK_ANY];
    
    [pastryController.refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
    [((id)pastryController.viewModel) verify];
}

- (void)test_numberOfSectionsInTableView_queries_collection_controller
{
    self.controller.viewModel = self.mockViewModel;
    
    [[self.mockGroupsArray expect] count];
    [self.controller numberOfSectionsInTableView:self.controller.tableView];
    [self.mockGroupsArray verify];
}

- (void)test_numberOfRowsInSection_queries_collection_controller_group
{
    self.controller.viewModel = self.mockViewModel;
    id mockGroup = [OCMockObject niceMockForClass:[MLVCCollectionControllerGroup class]];
    [[[self.mockCollectionController stub] andReturn:mockGroup] objectAtIndexedSubscript:3];
    id mockObjectsArray = [OCMockObject niceMockForClass:[NSArray class]];
    [[[mockGroup stub] andReturn:mockObjectsArray] objects];
    [[mockObjectsArray expect] count];
    
    [self.controller tableView:self.controller.tableView numberOfRowsInSection:3];
    [mockObjectsArray verify];
}

- (void)test_cellForRowAtIndexPath_queries_collection_controller
{
    self.controller.viewModel = self.mockViewModel;

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [[self.mockCollectionController expect] objectAtIndexPath:indexPath];
    [self.controller tableView:self.controller.tableView cellForRowAtIndexPath:indexPath];
    [self.mockCollectionController verify];
}

- (void)test_titleForHeaderInSection_queries_collection_controller_group
{
    self.controller.viewModel = self.mockViewModel;
    
    id mockGroup = [OCMockObject niceMockForClass:[MLVCCollectionControllerGroup class]];
    [[[self.mockCollectionController stub] andReturn:mockGroup] objectAtIndexedSubscript:1];
    [[mockGroup expect] title];
    [self.controller tableView:self.controller.tableView titleForHeaderInSection:1];
    [mockGroup verify];
}

@end
