//
//  UICollectionViewWaterfallLayout.h
//
//  Created by Nelson on 12/11/19.
//  Copyright (c) 2012 Nelson Tai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSTCollectionView.h"

@class UICollectionViewWaterfallLayout;

@protocol UICollectionViewDelegateWaterfallLayout <UICollectionViewDelegate>
- (CGFloat)collectionView:(PSUICollectionView *)collectionView
                   layout:(UICollectionViewWaterfallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface UICollectionViewWaterfallLayout : PSUICollectionViewLayout
@property(nonatomic, weak) id <UICollectionViewDelegateWaterfallLayout> delegate;
@property(nonatomic, assign) NSUInteger columnCount; // How many columns
@property(nonatomic, assign) CGFloat itemWidth; // Width for every column
@property(nonatomic, assign) UIEdgeInsets sectionInset; // The margins used to lay out content in a section
@end
