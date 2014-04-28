//
//  MLVCCollectionViewCellViewModel.h
//  MyLittleViewController
//
//  Created by derrick on 10/18/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MLVCCollectionViewCellViewModel <NSObject>
- (UICollectionViewCell *)collectionViewController:(MLVCCollectionViewController *)controller cellForItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionViewController:(MLVCCollectionViewController *)controller didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (BOOL)collectionViewController:(MLVCCollectionViewController *)controller shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPaht;

- (CGSize)collectionViewController:(MLVCCollectionViewController *)controller layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
@end
