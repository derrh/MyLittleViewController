//
//  MLVCCollectionViewCellAdapter.h
//  MyLittleViewController
//
//  Created by derrick on 10/18/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MLVCCollectionViewCellAdapter <NSObject>
- (UICollectionViewCell *)collectionViewController:(UICollectionViewController *)controller cellForItemAtIndexPath:(NSIndexPath *)indexPath;
@end
