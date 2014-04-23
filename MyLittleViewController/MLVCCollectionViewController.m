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
#import "UICollectionView+MyLittleViewController.h"

@interface MLVCCollectionViewController () <UICollectionViewDelegateFlowLayout>
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
    
    if (self.viewModel) {
        [self.collectionView mlvc_observeCollectionController:_viewModel.collectionController];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.viewModel respondsToSelector:@selector(viewController:viewWillAppear:)]) {
        [self.viewModel viewController:self viewWillAppear:animated];
    }

    if ([self.viewModel respondsToSelector:@selector(refreshViewModelSignalForced:)]) {
        [self.viewModel refreshViewModelSignalForced:NO];
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self.viewModel respondsToSelector:@selector(viewController:viewWillDisappear:)]) {
        [self.viewModel viewController:self viewWillDisappear:animated];
    }
}


- (void)setViewModel:(id<MLVCCollectionViewModel>)viewModel
{
    if (_viewModel == viewModel) {
        return;
    }
    
    _viewModel = viewModel;
    
    if (self.isViewLoaded)
    {
        if ([self.viewModel respondsToSelector:@selector(viewControllerViewDidLoad:)]) {
            [self.viewModel viewControllerViewDidLoad:self];
        }
        if ([self.viewModel respondsToSelector:@selector(collectionViewControllerViewDidLoad:)]) {
            [self.viewModel collectionViewControllerViewDidLoad:self];
        }

        [self.collectionView mlvc_observeCollectionController:_viewModel.collectionController];
        [self.collectionView reloadData];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.viewModel.collectionController.groups count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id<MLVCCollectionControllerGroup> group = self.viewModel.collectionController[section];
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

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPaht
{
    id<MLVCCollectionViewCellViewModel> item = [self.viewModel.collectionController objectAtIndexPath:indexPaht];

    if ([item respondsToSelector:@selector(collectionViewController:shouldDeselectItemAtIndexPath:)]) {
        return [item collectionViewController:self shouldDeselectItemAtIndexPath:indexPaht];
    }
    
    return YES;
}

- (UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout
{
    UICollectionViewTransitionLayout *transitionLayout = [[UICollectionViewTransitionLayout alloc] initWithCurrentLayout:fromLayout nextLayout:toLayout];
    return transitionLayout;
}

@end
