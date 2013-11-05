//
//  MLVCCollectionViewController.m
//  MyLittleViewController
//
//  Created by derrick on 10/18/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import "MLVCCollectionViewController.h"
#import "MLVCCollectionViewCellAdapter.h"

@interface MLVCCollectionViewController ()

@end

@implementation MLVCCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.viewModel respondsToSelector:@selector(collectionViewControllerViewDidLoad:)]) {
        [self.viewModel collectionViewControllerViewDidLoad:self];
    }
}

- (void)setViewModel:(MLVCCollectionViewModel *)viewModel
{
    _viewModel = viewModel;

    [self.viewModel.collectionController.groupsInsertedIndexSetSignal subscribeNext:^(NSIndexSet *sections) {
        [self.collectionView insertSections:sections];
    }];
    
    [self.viewModel.collectionController.groupsDeletedIndexSetSignal subscribeNext:^(NSIndexSet *sections) {
        [self.collectionView deleteSections:sections];
    }];
    
    [self.viewModel.collectionController.objectsInsertedIndexPathsSignal subscribeNext:^(NSArray *indexPaths) {
        [self.collectionView insertItemsAtIndexPaths:indexPaths];
    }];
    
    [self.viewModel.collectionController.objectsDeletedIndexPathsSignal subscribeNext:^(NSArray *indexPaths) {
        [self.collectionView deleteItemsAtIndexPaths:indexPaths];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.viewModel respondsToSelector:@selector(refreshViewModelWithCompletionBlock:)]) {
        [self.viewModel refreshViewModelWithCompletionBlock:nil];
    }
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
    id<MLVCCollectionViewCellAdapter> item = [self.viewModel.collectionController objectAtIndexPath:indexPath];
    return [item collectionViewController:self cellForItemAtIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.viewModel respondsToSelector:@selector(collectionViewController:didSelectItemAtIndexPath:)]) {
        [self.viewModel collectionViewController:self didSelectItemAtIndexPath:indexPath];
    }
}

@end
