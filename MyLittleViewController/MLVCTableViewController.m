//
//  MLVCTableViewController.m
//  MyLittleViewController
//
//  Created by derrick on 10/4/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import "MLVCTableViewController.h"
#import "MLVCCollectionController.h"
#import "MLVCTableViewCellAdapter.h"

@interface MLVCTableViewController ()
@end

@implementation MLVCTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.viewModel respondsToSelector:@selector(viewDidLoadForController:)]) {
        [self.viewModel viewDidLoadForController:self];
    }
}

- (void)refreshFromRefreshControl:(UIRefreshControl *)refreshControl
{
    [self.viewModel refreshViewModelWithCompletionBlock:^{
        [refreshControl endRefreshing];
    }];
}

- (void)setViewModel:(MLVCCollectionViewModel *)viewModel
{
    if (_viewModel == viewModel) {
        return;
    }
    
    _viewModel = viewModel;
    [self.tableView reloadData];
    
    [self.viewModel.collectionController.groupsInsertedIndexSetSignal subscribeNext:^(id x) {
        [self.tableView insertSections:x withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
    [self.viewModel.collectionController.objectsInsertedIndexPathsSignal subscribeNext:^(id x) {
        [self.tableView insertRowsAtIndexPaths:x withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
    if ([_viewModel respondsToSelector:@selector(refreshViewModelWithCompletionBlock:)]) {
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self action:@selector(refreshFromRefreshControl:) forControlEvents:UIControlEventValueChanged];
    } else {
        self.refreshControl = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.viewModel respondsToSelector:@selector(refreshViewModelWithCompletionBlock:)]) {
        [self.viewModel refreshViewModelWithCompletionBlock:nil];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.viewModel.collectionController.groups count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    MLVCCollectionControllerGroup *group = self.viewModel.collectionController[section];
    return group.title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MLVCCollectionControllerGroup *group = self.viewModel.collectionController[section];
    return [group.objects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<MLVCTableViewCellAdapter> cellAdapter = [self.viewModel.collectionController objectAtIndexPath:indexPath];
    return [cellAdapter cellForTableViewController:self forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.viewModel cellSelectedAtIndexPath:indexPath inController:self];
}

@end
