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

#define SYNTHESIZE_NONATOMIC(class, getter, setter, objcAssociation) \
- (class *)getter { \
return objc_getAssociatedObject(self, _cmd); \
} \
\
- (void)setter:(class *)object { \
objc_setAssociatedObject(self, @selector(getter), object, objcAssociation);\
}

#define SYNTHESIZE_STRONG_NONATOMIC(class, getter, setter) \
SYNTHESIZE_NONATOMIC(class, getter, setter, OBJC_ASSOCIATION_RETAIN)

@interface UICollectionView (MyLittleViewControllerInternal)
@property (nonatomic) RACDisposable *beginUpdates, *insert, *delete, *insertGroup, *deleteGroup, *endUpdates;
@property (nonatomic, weak) MLVCCollectionController *observedCollectionController;
@end

@implementation UICollectionView (MyLittleViewController)

SYNTHESIZE_STRONG_NONATOMIC(RACDisposable, insert, setInsert)
SYNTHESIZE_STRONG_NONATOMIC(RACDisposable, delete, setDelete)
SYNTHESIZE_STRONG_NONATOMIC(RACDisposable, insertGroup, setInsertGroup)
SYNTHESIZE_STRONG_NONATOMIC(RACDisposable, deleteGroup, setDeleteGroup)
SYNTHESIZE_STRONG_NONATOMIC(RACDisposable, endUpdates, setEndUpdates)
SYNTHESIZE_STRONG_NONATOMIC(RACDisposable, beginUpdates, setBeginUpdates)
SYNTHESIZE_NONATOMIC(MLVCCollectionController, observedCollectionController, setObservedCollectionController, OBJC_ASSOCIATION_ASSIGN);

- (void)endObservingCollectionChanges
{
    [self.beginUpdates dispose];
    self.beginUpdates = nil;
    
    [self.endUpdates dispose];
    self.endUpdates = nil;
    
    [self.insertGroup dispose];
    self.insertGroup = nil;
    
    [self.deleteGroup dispose];
    self.deleteGroup = nil;
    
    [self.insert dispose];
    self.insert = nil;
    
    [self.delete dispose];
    self.delete = nil;

    self.observedCollectionController = nil;
}

- (void)mlvc_observeCollectionController:(MLVCCollectionController *)collectionController
{
    if (collectionController == self.observedCollectionController) {
        return;
    }
    [self endObservingCollectionChanges];
    
    NSMutableArray *changes = [NSMutableArray array];
    __block BOOL performingBatchUpdates = NO;
    
    self.beginUpdates = [collectionController.beginUpdatesSignal subscribeNext:^(id x) {
        performingBatchUpdates = YES;
    }];
    
    @weakify(self);
    self.endUpdates = [collectionController.endUpdatesSignal subscribeNext:^(id x) {
        @strongify(self);
        [self performBatchUpdates:^{
            for (void (^collectionViewUpdateBlock)(UICollectionView *) in changes) {
                collectionViewUpdateBlock(self);
            }
            [changes removeAllObjects];
            performingBatchUpdates = NO;
        } completion:nil];
    }];
    
    self.insertGroup = [collectionController.groupsInsertedIndexSetSignal subscribeNext:^(NSIndexSet *sections) {
        @strongify(self);
        if (performingBatchUpdates) {
            [changes addObject:^() {
                @strongify(self);
                [self insertSections:sections];
            }];
        } else {
            [self insertSections:sections];
        }
    }];
    
    self.deleteGroup = [collectionController.groupsDeletedIndexSetSignal subscribeNext:^(NSIndexSet *sections) {
        @strongify(self);
        if (performingBatchUpdates) {
            [changes addObject:^() {
                @strongify(self);
                [self deleteSections:sections];
            }];
        } else {
            [self deleteSections:sections];
        }
    }];
    
    self.insert = [collectionController.objectsInsertedIndexPathsSignal subscribeNext:^(NSArray *indexPaths) {
        @strongify(self);
        if (performingBatchUpdates) {
            [changes addObject:^() {
                @strongify(self);
                [self insertItemsAtIndexPaths:indexPaths];
            }];
        } else {
            [self insertItemsAtIndexPaths:indexPaths];
        }
    }];
    
    self.delete = [collectionController.objectsDeletedIndexPathsSignal subscribeNext:^(NSArray *indexPaths) {
        @strongify(self);
        if (performingBatchUpdates) {
            [changes addObject:^() {
                @strongify(self);
                [self deleteItemsAtIndexPaths:indexPaths];
            }];
        } else {
            [self deleteItemsAtIndexPaths:indexPaths];
        }
    }];
    
    self.observedCollectionController = collectionController;

}

@end
