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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setViewModel:(MLVCCollectionViewModel *)viewModel
{
    _viewModel = viewModel;

    [self.viewModel.collectionController.groupsInsertedIndexSetSignal subscribeNext:^(NSIndexSet *sections) {
        [self.collectionView insertSections:sections];
    }];
    
    [self.viewModel.collectionController.objectsInsertedIndexPathsSignal subscribeNext:^(NSArray *indexPaths) {
        [self.collectionView insertItemsAtIndexPaths:indexPaths];
    }];
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

@end
