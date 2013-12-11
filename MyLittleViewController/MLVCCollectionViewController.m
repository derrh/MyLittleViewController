//
//  MLVCCollectionViewController.m
//  MyLittleViewController
//
//  Created by derrick on 10/18/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import "MLVCCollectionViewController.h"
#import "MLVCCollectionViewCellViewModel.h"
#import "MLVCCollectionController.h"

@interface MLVCCollectionViewController () <UICollectionViewDelegateFlowLayout>
@property (nonatomic) RACDisposable *groupInserted, *groupDeleted, *objectInserted, *objectDeleted;
@end

@implementation MLVCCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.viewModel respondsToSelector:@selector(viewControllerViewDidLoad:)]) {
        [self.viewModel viewControllerViewDidLoad:self];
    }
    
    if ([self.viewModel respondsToSelector:@selector(collectionViewControllerViewDidLoad:)]) {
        [self.viewModel collectionViewControllerViewDidLoad:self];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.viewModel respondsToSelector:@selector(viewController:viewWillAppear:)]) {
        [self.viewModel viewController:self viewWillAppear:animated];
    }
    
    if ([self.viewModel respondsToSelector:@selector(refreshViewModelForced:withCompletionBlock:)]) {
        [self.viewModel refreshViewModelForced:NO withCompletionBlock:nil];
    }
}

- (void)endObservingCollectionChanges
{
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
    __weak MLVCCollectionViewController *weakSelf = self;
    
    self.groupInserted = [self.viewModel.collectionController.groupsInsertedIndexSetSignal subscribeNext:^(NSIndexSet *sections) {
        [weakSelf.collectionView insertSections:sections];
    }];
    
    self.groupDeleted = [self.viewModel.collectionController.groupsDeletedIndexSetSignal subscribeNext:^(NSIndexSet *sections) {
        [weakSelf.collectionView deleteSections:sections];
    }];
    
    self.objectInserted = [self.viewModel.collectionController.objectsInsertedIndexPathsSignal subscribeNext:^(NSArray *indexPaths) {
        [weakSelf.collectionView insertItemsAtIndexPaths:indexPaths];
    }];
    
    self.objectDeleted = [self.viewModel.collectionController.objectsDeletedIndexPathsSignal subscribeNext:^(NSArray *indexPaths) {
        [weakSelf.collectionView deleteItemsAtIndexPaths:indexPaths];
    }];
}

- (void)setViewModel:(id<MLVCCollectionViewModel>)viewModel
{
    if (_viewModel == viewModel) {
        return;
    }
    
    [self endObservingCollectionChanges];
    
    _viewModel = viewModel;
    
    if (self.isViewLoaded)
    {
        if ([self.viewModel respondsToSelector:@selector(viewControllerViewDidLoad:)]) {
            [self.viewModel viewControllerViewDidLoad:self];
        }
        if ([self.viewModel respondsToSelector:@selector(collectionViewControllerViewDidLoad:)]) {
            [self.viewModel collectionViewControllerViewDidLoad:self];
        }
        [self.collectionView reloadData];
    }

    [self beginObservingCollectionChanges];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.viewModel.collectionController.groups count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    MLVCCollectionControllerGroup *group = self.viewModel.collectionController[section];
    return [group.objects count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<MLVCCollectionViewCellViewModel> item = [self.viewModel.collectionController objectAtIndexPath:indexPath];
    return [item collectionViewController:self cellForItemAtIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<MLVCCollectionViewCellViewModel> item = [self.viewModel.collectionController objectAtIndexPath:indexPath];
    [item collectionViewController:self didSelectItemAtIndexPath:indexPath];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSAssert([self.viewModel respondsToSelector:@selector(collectionViewController:viewForSupplementaryElementOfKind:atIndexPath:)], @"The view model for your MLVCCollectionViewController must implement this method");
    
    return [self.viewModel collectionViewController:self viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
}


#pragma mark - UICollectionViewDelegateFlowLayout

@end
