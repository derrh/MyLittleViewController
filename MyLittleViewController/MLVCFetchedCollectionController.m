//
//  MLVCFetchedCollectionController.m
//  MyLittleViewController
//
//  Created by Derrick Hathaway on 4/26/14.
//  Copyright (c) 2014 Instructure. All rights reserved.
//

#import "MLVCFetchedCollectionController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MLVCFetchedCollectionController () <NSFetchedResultsControllerDelegate>
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation MLVCFetchedCollectionController

- (id)initWithFetchedResultsController:(NSFetchedResultsController *)frc
{
    self = [super init];
    if (self) {
        self.fetchedResultsController = frc;
        frc.delegate = self;
    }
    return self;
}

- (RACSignal *)beginUpdatesSignal
{
    return [self rac_signalForSelector:@selector(controllerWillChangeContent:) fromProtocol:@protocol(NSFetchedResultsControllerDelegate)];
}

- (RACSignal *)endUpdatesSignal
{
    return [self rac_signalForSelector:@selector(controllerDidChangeContent:) fromProtocol:@protocol(NSFetchedResultsControllerDelegate)];
}

- (RACSignal *)groupChangedIndexSignalForChangeType:(NSFetchedResultsChangeType)type
{
    return [[[self rac_signalForSelector:@selector(controller:didChangeSection:atIndex:forChangeType:) fromProtocol:@protocol(NSFetchedResultsControllerDelegate)]

    filter:^BOOL(RACTuple *change) {
        return [change.fourth integerValue] == type;
    }]

    map:^id(RACTuple *change) {
        return [NSIndexSet indexSetWithIndex:[change.third unsignedIntegerValue]];
    }];
}

- (RACSignal *)groupsInsertedIndexSetSignal
{
    return [self groupChangedIndexSignalForChangeType:NSFetchedResultsChangeInsert];
}

- (RACSignal *)groupsDeletedIndexSetSignal
{
    return [self groupChangedIndexSignalForChangeType:NSFetchedResultsChangeDelete];
}


- (RACSignal *)objectChangedIndexPathsSignalForChangeType:(NSFetchedResultsChangeType)type
{
    return [[[self rac_signalForSelector:@selector(controller:didChangeObject:atIndexPath:forChangeType:newIndexPath:) fromProtocol:@protocol(NSFetchedResultsControllerDelegate)]

    filter:^BOOL(RACTuple *change) {
        return [change.fourth integerValue] == type;
    }]

    map:^id(RACTuple *change) {
        return RACTuplePack(change.third, change.fifth);
    }];
}

- (RACSignal *)objectsInsertedIndexPathsSignal
{
    return [[self objectChangedIndexPathsSignalForChangeType:NSFetchedResultsChangeInsert] map:^(RACTuple *change){
        return @[change.second];
    }];
}

- (RACSignal *)objectsDeletedIndexPathsSignal
{
    return [[self objectChangedIndexPathsSignalForChangeType:NSFetchedResultsChangeDelete] map:^(RACTuple *change){
        return @[change.first];
    }];
}

- (RACSignal *)objectsUpdatedIndexPathsSignal
{
    return [[self objectChangedIndexPathsSignalForChangeType:NSFetchedResultsChangeUpdate] map:^(RACSignal *change) {
        return @[change.first];
    }];
}

- (RACSignal *)objectMovedFromIndexPathToIndexPathSignal
{
    return [self objectChangedIndexPathsSignalForChangeType:NSFetchedResultsChangeMove];
}



- (NSArray *)groups
{
    return self.fetchedResultsController.sections;
}

- (id (^)(id))viewModelFactory
{
    if (_viewModelFactory) {
        return _viewModelFactory;
    }
    
    return _viewModelFactory = ^(id model) { return model; };
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return self.viewModelFactory([self.fetchedResultsController objectAtIndexPath:indexPath]);
}


#pragma mark - 

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {}
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {}
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {}

@end
