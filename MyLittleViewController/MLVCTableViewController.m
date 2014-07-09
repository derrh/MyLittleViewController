//
//  MLVCTableViewController.m
//  MyLittleViewController
//
//  Created by derrick on 10/4/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import "MLVCTableViewController.h"
#import "MLVCCollectionController.h"
#import "MLVCTableViewCellViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MLVCTableViewController ()
@property (nonatomic) RACDisposable *beginUpdates, *endUpdates, *groupInserted, *groupDeleted, *objectInserted, *objectDeleted;
@end

@implementation MLVCTableViewController {
    RACSubject *_selectedCellViewModelSubject;
    RACSubject *_tableViewDidAppearSubject;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.viewModel respondsToSelector:@selector(viewControllerViewDidLoad:)]) {
        [self.viewModel viewControllerViewDidLoad:self];
    }
    
    if ([self.viewModel respondsToSelector:@selector(tableViewControllerViewDidLoad:)]) {
        [self.viewModel tableViewControllerViewDidLoad:self];
    }
    
    [_selectedCellViewModelSubject sendNext:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([self.viewModel respondsToSelector:@selector(viewController:viewDidAppear:)]) {
        [self.viewModel viewController:self viewDidAppear:animated];
    }
    
    [_tableViewDidAppearSubject sendNext:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.viewModel respondsToSelector:@selector(viewController:viewWillAppear:)]) {
        [self.viewModel viewController:self viewWillAppear:animated];
    }
    
    if ([self.viewModel respondsToSelector:@selector(refreshViewModelSignalForced:)]) {
        RACSignal *refreshSignal = [self.viewModel refreshViewModelSignalForced:NO];
        [self.refreshControl beginRefreshing];
        [self.customRefreshControl beginRefreshing];
        [self.tableView scrollRectToVisible:self.refreshControl.frame animated:NO];
        [refreshSignal subscribeCompleted:^{
            [self.refreshControl endRefreshing];
            [self.customRefreshControl endRefreshing];
            if (self.viewModel.tableviewRefreshCompleted){
                self.viewModel.tableviewRefreshCompleted();
            }
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self.viewModel respondsToSelector:@selector(viewController:viewWillDisappear:)]) {
        [self.viewModel viewController:self viewWillDisappear:animated];
    }
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    if ([self.viewModel respondsToSelector:@selector(allowsMultipleSelectionDuringEditing)] && self.viewModel.allowsMultipleSelectionDuringEditing) {
        self.tableView.allowsMultipleSelectionDuringEditing = editing;
    }
    [super setEditing:editing animated:animated];
}

- (void)refreshFromRefreshControl:(id)refreshControl
{
    if ([self.viewModel respondsToSelector:@selector(refreshViewModelSignalForced:)]) {
        [[self.viewModel refreshViewModelSignalForced:YES] subscribeCompleted:^{
            [refreshControl endRefreshing];
            [self.customRefreshControl endRefreshing];
        }];
    }
}

- (void)endObservingCollectionChanges
{
    [self.beginUpdates dispose];
    [self.endUpdates dispose];
    
    [self.groupInserted dispose];
    self.groupInserted = nil;
    
    [self.groupDeleted dispose];
    self.groupDeleted = nil;
    
    [self.objectInserted dispose];
    self.objectInserted = nil;
    
    [self.objectDeleted dispose];
    self.objectDeleted = nil;
}

- (void)beginObservingCollectionChanges
{
    __weak MLVCTableViewController *weakSelf = self;
    
    self.beginUpdates = [self.viewModel.collectionController.beginUpdatesSignal subscribeNext:^(id x) {
        [weakSelf.tableView beginUpdates];
    }];
    
    self.endUpdates = [self.viewModel.collectionController.endUpdatesSignal subscribeNext:^(id x) {
        [weakSelf.tableView endUpdates];
    }];
    
    self.groupInserted = [self.viewModel.collectionController.groupsInsertedIndexSetSignal subscribeNext:^(id x) {
        [weakSelf.tableView insertSections:x withRowAnimation:UITableViewRowAnimationTop];
    }];
    
    self.groupDeleted = [self.viewModel.collectionController.groupsDeletedIndexSetSignal subscribeNext:^(id x) {
        [weakSelf.tableView deleteSections:x withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    self.objectInserted = [self.viewModel.collectionController.objectsInsertedIndexPathsSignal subscribeNext:^(id x) {
        [weakSelf.tableView insertRowsAtIndexPaths:x withRowAnimation:UITableViewRowAnimationTop];
    }];
    
    self.objectDeleted = [self.viewModel.collectionController.objectsDeletedIndexPathsSignal subscribeNext:^(id x) {
        [weakSelf.tableView deleteRowsAtIndexPaths:x withRowAnimation:UITableViewRowAnimationFade];
    }];
    
}

- (void)setViewModel:(id<MLVCTableViewModel>)viewModel
{
    if (_viewModel == viewModel) {
        return;
    }
    
    [self endObservingCollectionChanges];
    
    _viewModel = viewModel;
    if (self.isViewLoaded) {
        if ([_viewModel respondsToSelector:@selector(viewControllerViewDidLoad:)]) {
            [_viewModel viewControllerViewDidLoad:self];
        }
        if ([_viewModel respondsToSelector:@selector(tableViewControllerViewDidLoad:)]) {
            [_viewModel tableViewControllerViewDidLoad:self];
        }
        [self.tableView reloadData];
    }
    
    [self beginObservingCollectionChanges];
    
    if ([_viewModel respondsToSelector:@selector(refreshViewModelSignalForced:)]) {
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self action:@selector(refreshFromRefreshControl:) forControlEvents:UIControlEventValueChanged];
    } else {
        self.refreshControl = nil;
    }
}

#pragma mark - selection

- (RACSignal *)selectedCellViewModelSignal
{
    return _selectedCellViewModelSubject ?: (_selectedCellViewModelSubject = [RACSubject subject]);
}

- (RACSignal *)tableViewDidAppearSignal
{
    return _tableViewDidAppearSubject ?: (_tableViewDidAppearSubject = [RACSubject subject]);
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
    id<MLVCTableViewCellViewModel> cellViewModel = [self.viewModel.collectionController objectAtIndexPath:indexPath];
    return [cellViewModel tableViewController:self cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<MLVCTableViewCellViewModel> cellViewModel = [self.viewModel.collectionController objectAtIndexPath:indexPath];
    if ([cellViewModel respondsToSelector:@selector(tableViewController:didSelectRowAtIndexPath:)]) {
        [cellViewModel tableViewController:self didSelectRowAtIndexPath:indexPath];
    }
    [_selectedCellViewModelSubject sendNext:cellViewModel];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<MLVCTableViewCellViewModel> cellViewModel = [self.viewModel.collectionController objectAtIndexPath:indexPath];
    if ([cellViewModel respondsToSelector:@selector(tableViewController:shouldHighlightRowAtIndexPath:)]) {
        return [cellViewModel tableViewController:self shouldHighlightRowAtIndexPath:indexPath];
    }
    return YES;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<MLVCTableViewCellViewModel> cellViewModel = [self.viewModel.collectionController objectAtIndexPath:indexPath];
    if ([cellViewModel respondsToSelector:@selector(tableViewController:willSelectRowAtIndexPath:)]) {
        return [cellViewModel tableViewController:self willSelectRowAtIndexPath:indexPath];
    }
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_selectedCellViewModelSubject sendNext:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<MLVCTableViewCellViewModel> cellViewModel = [self.viewModel.collectionController objectAtIndexPath:indexPath];
    if ([cellViewModel respondsToSelector:@selector(tableViewController:heightForRowAtIndexPath:)]) {
        return [cellViewModel tableViewController:self heightForRowAtIndexPath:indexPath];
    }
    return tableView.rowHeight;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<MLVCTableViewCellViewModel> cellViewModel = [self.viewModel.collectionController objectAtIndexPath:indexPath];
    if ([cellViewModel respondsToSelector:@selector(tableViewController:canEditRowAtIndexPath:)]) {
        return [cellViewModel tableViewController:self canEditRowAtIndexPath:indexPath];
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<MLVCTableViewCellViewModel> cellViewModel = [self.viewModel.collectionController objectAtIndexPath:indexPath];
    if ([cellViewModel respondsToSelector:@selector(tableViewController:commitEditingStyle:forRowAtIndexPath:)]) {
        [cellViewModel tableViewController:self commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<MLVCTableViewCellViewModel> cellViewModel = [self.viewModel.collectionController objectAtIndexPath:indexPath];
    if ([cellViewModel respondsToSelector:@selector(tableViewController:titleForDeleteConfirmationButtonForRowAtIndexPath:)]) {
        return [cellViewModel tableViewController:self titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
    }
    return NSLocalizedString(@"Delete", @"Default delete button MLVC");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[self.customRefreshControl scrollViewDidScroll:scrollView];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
	[self.customRefreshControl scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
}

- (void)dealloc
{
    [self endObservingCollectionChanges];
}

@end
