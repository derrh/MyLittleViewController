//
//  MLVCTableViewControllerSpec.m
//  MyLittleViewController
//
//  Created by derrick on 10/4/13.
//  Copyright 2013 Instructure. All rights reserved.
//

#import "Kiwi.h"
#import "MLVCTableViewController.h"
#import "PastriesViewModel.h"
#import "Pastry.h"
#import "Pastry+TableViewAdapter.h"

SPEC_BEGIN(MLVCTableViewControllerSpec)

describe(@"MLVCTableViewController", ^{
    MLVCTableViewController *controller = [MLVCTableViewController new];
    controller.viewModel = [PastriesViewModel new];

    [controller.viewModel.collectionController insertObjects:@[[Pastry pastryNamed:@"Lemon Tart" calories:180 type:PastryTypeLemon]]];
    
    context(@"when controller's viewModel property is set", ^{
        it(@"sets it sets itself as the collectionController's delegate", ^{
            [[controller should] equal:controller.viewModel.collectionController.delegate];
        });
    });
    
    context(@"when the dataSource is queried", ^{
        it(@"calls the group's count method", ^{
            [[controller.viewModel.collectionController.groups should] receive:@selector(count) andReturn:theValue(1)];
            [controller numberOfSectionsInTableView:nil];
        });
        
        it(@"calls the group's objects array's count method", ^{
            MLVCCollectionControllerGroup *group = controller.viewModel.collectionController[0];
            [[group.objects should] receive:@selector(count) andReturn:theValue(1)];
            [controller tableView:controller.tableView numberOfRowsInSection:0];
        });
        
        it(@"calls the adapter's cell method", ^{
            Pastry *pastry = controller.viewModel.collectionController[0][0];
            [[pastry should] receive:@selector(cellForTableViewController:forIndexPath:) withArguments:any(), [NSIndexPath indexPathForRow:0 inSection:0]];
            [controller tableView:controller.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        });
        
        it(@"uses the group's title for the tableview section", ^{
            MLVCCollectionControllerGroup *group = controller.viewModel.collectionController[0];
            [[group should] receive:@selector(title)];
            [controller tableView:controller.tableView titleForHeaderInSection:0];
        });
    });
    
    context(@"When the cells are tapped", ^{
        it(@"should forward the tap on to the pastry", ^{
            Pastry *pastry = controller.viewModel.collectionController[0][0];
            [[pastry should] receive:@selector(cellForTableViewController:forIndexPath:) withArguments:any(), [NSIndexPath indexPathForRow:0 inSection:0]];
            [controller tableView:controller.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        });
    });
    
    context(@"when delegate methods are invoked", ^{
        [controller view];
        
        it(@"calls tableview update methods", ^{
            [[controller.tableView should] receive:@selector(beginUpdates)];
            [[controller.tableView should] receive:@selector(insertSections:withRowAnimation:) withArguments:any(), any()];
            [[controller.tableView should] receive:@selector(insertRowsAtIndexPaths:withRowAnimation:) withArguments:any(), any()];
            [[controller.tableView should] receive:@selector(endUpdates)];
            
            [controller.viewModel.collectionController insertObjects:@[[Pastry pastryNamed:@"Chocolate Eclair" calories:320 type:PastryTypeChocolate]]];
        });
    });
});

SPEC_END
