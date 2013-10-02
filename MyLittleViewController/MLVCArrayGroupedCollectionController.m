//
//  MLVCArrayGroupedCollectionController.m
//  MyLittleViewController
//
//  Created by derrick on 10/2/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import "MLVCArrayGroupedCollectionController.h"

@interface MLVCArrayGroupedCollectionController ()
@property (nonatomic, copy, readwrite) NSString *groupKeyPath;
@property (nonatomic, copy, readwrite) NSString *(^groupTitleBlock)(id object);
@property (nonatomic, copy, readwrite) NSArray *sortDescriptors;
@end

@implementation MLVCArrayGroupedCollectionController

+ (instancetype)collectionControllerGroupingBy:(NSString *)groupKey groupTitleBlock:(NSString *(^)(id object))groupTitleBlock sortDescriptors:(NSArray *)sortDescriptors
{
    MLVCArrayGroupedCollectionController *me = [[self alloc] init];
    me.groupKeyPath = [groupKey copy];
    me.groupTitleBlock = groupTitleBlock;
    me.sortDescriptors = [sortDescriptors copy];
    return me;
}

@end
