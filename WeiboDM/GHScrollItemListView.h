//
//  GHScrollItemListView.h
//  notebook
//
//  Created by Stephen Liu on 12-8-28.
//  Copyright (c) 2012年 ifuninfo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GHScrollItemListView;
@protocol GHScrollItemListViewDelegate <NSObject>
- (void)ScrollItemListView:(GHScrollItemListView *)listView didSelectItemAtIndex:(NSInteger)index;
@end

@interface GHScrollItemListView : UIView
@property(nonatomic,assign)id<GHScrollItemListViewDelegate> delegate;
@property(nonatomic,retain)NSArray *items;
@property(nonatomic,assign)NSInteger selectedIndex;
- (NSDictionary *)selectedItem;
- (id)initWithItems:(NSArray *)items;
- (void)scrollToIndex:(NSInteger)index;
@end
