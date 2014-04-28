//
//  MLVCFetchedCollectionController.h
//  MyLittleViewController
//
//  Created by Derrick Hathaway on 4/26/14.
//  Copyright (c) 2014 Instructure. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLVCCollectionController.h"

@interface MLVCFetchedCollectionController : NSObject <MLVCCollectionController>
- (id)initWithFetchedResultsController:(NSFetchedResultsController *)frc;

@property (nonatomic, copy) id (^viewModelFactory)(id model);
@end
