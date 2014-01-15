//
//  UICollectionView+MyLittleViewController.m
//  MyLittleViewController
//
//  Created by derrick on 12/21/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import "UICollectionView+MyLittleViewController.h"
#import "MLVCCollectionController.h"
#import <objc/runtime.h>
#import <Mantle/EXTScope.h>

#define SYNTHESIZE_STRONG_NONATOMIC(class, getter, setter) \
- (class *)getter { \
return objc_getAssociatedObject(self, _cmd); \
} \
\
- (void)setter:(class *)object { \
objc_setAssociatedObject(self, @selector(getter), object, OBJC_ASSOCIATION_RETAIN);\
}


@interface UICollectionView (MyLittleViewControllerInternal)
@property (nonatomic) RACDisposable *insert, *delete, *insertGroup, *deleteGroup;
@end

@implementation UICollectionView (MyLittleViewController)

SYNTHESIZE_STRONG_NONATOMIC(RACDisposable, insert, setInsert)
SYNTHESIZE_STRONG_NONATOMIC(RACDisposable, delete, setDelete)
SYNTHESIZE_STRONG_NONATOMIC(RACDisposable, insertGroup, setInsertGroup)
SYNTHESIZE_STRONG_NONATOMIC(RACDisposable, deleteGroup, setDeleteGroup)

- (void)endObservingCollectionChanges
{
    [self.insertGroup dispose];
    self.insertGroup = nil;
    
    [self.deleteGroup dispose];
    self.deleteGroup = nil;
    
    [self.insert dispose];
    self.insert = nil;
    
    [self.delete dispose];
    self.delete = nil;
}

- (void)mlvc_observeCollectionController:(MLVCCollectionController *)collectionController
{
    [self endObservingCollectionChanges];
    @weakify(self)
    self.insertGroup = [collectionController.groupsInsertedIndexSetSignal subscribeNext:^(NSIndexSet *sections) {
        @strongify(self)
        [self insertSections:sections];
    }];
    
    self.deleteGroup = [collectionController.groupsDeletedIndexSetSignal subscribeNext:^(NSIndexSet *sections) {
        @strongify(self)
        [self deleteSections:sections];
    }];
    
    self.insert = [collectionController.objectsInsertedIndexPathsSignal subscribeNext:^(NSArray *indexPaths) {
        @strongify(self)
        [self insertItemsAtIndexPaths:indexPaths];
    }];
    
    self.delete = [collectionController.objectsDeletedIndexPathsSignal subscribeNext:^(NSArray *indexPaths) {
        @strongify(self)
        [self deleteItemsAtIndexPaths:indexPaths];
    }];
}

@end
