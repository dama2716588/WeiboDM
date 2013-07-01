//
//  GHScrollItemListView.m
//  notebook
//
//  Created by Stephen Liu on 12-8-28.
//  Copyright (c) 2012年 ifuninfo. All rights reserved.
//

#import "GHScrollItemListView.h"

@interface GHScrollItemListView(){
    UIScrollView *contentView;
    UIImageView *selectedBox;
}
@end

@implementation GHScrollItemListView
@synthesize delegate = _delegate;
@synthesize selectedIndex = _selectedIndex;
@synthesize items = _items;

- (void)dealloc{
    [contentView release];
    [_items release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        contentView = [[UIScrollView alloc] initWithFrame:self.bounds];
        contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [contentView setBackgroundColor:[UIColor clearColor]];
        contentView.showsHorizontalScrollIndicator = NO;
        contentView.showsVerticalScrollIndicator = NO;
        [self addSubview:contentView];
        selectedBox = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cam_lomo_selected"]];
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return self;
}

- (id)initWithItems:(NSArray *)items{
    if (self = [self init]) {
        self.items = items;
    }
    return self;
}

- (void)reloadItems{
    [contentView removeAllSubviews];
    CGFloat x = 0;
    CGFloat y = 10;
    NSInteger index = 0;
    for (NSDictionary *item in _items) {
        x += 8;
        NSString *image = [item objectForKey:@"image"];
        NSString *selectedImage = [item objectForKey:@"selectedImage"];
        NSString *title = [item objectForKey:@"title"];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:selectedImage] forState:UIControlStateHighlighted];
        [button addTarget:self  action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(x, y, 50, 50);
        button.tag = 1000 + index;
        [contentView addSubview:button];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x-3, y + 50, 56, 20)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = title;
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [contentView addSubview:titleLabel];
        [titleLabel release];
        
        index += 1;

        x += 50;
        x += 8;
    }
    contentView.contentSize = CGSizeMake(x, contentView.height);
    [contentView addSubview:selectedBox];
    [selectedBox setCenter:[self centerForIndex:_selectedIndex]];
}

- (NSDictionary *)selectedItem{
    if (self.items.count > _selectedIndex&&_selectedIndex>=0) {
        return [self.items objectAtIndex:_selectedIndex];
    }
    return nil;
}

- (void)itemSelected:(UIButton *)sender{
    NSInteger index = [sender tag] - 1000;
    if ([_delegate respondsToSelector:@selector(ScrollItemListView:didSelectItemAtIndex:)]) {
        [_delegate ScrollItemListView:self didSelectItemAtIndex:index];
    }
    self.selectedIndex = index;
}

- (void)setItems:(NSArray *)items{
    if (items!=_items) {
        [_items release];
        _items = [items retain];
        [self reloadItems];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    if (selectedIndex>=0&&selectedIndex<=_items.count) {
         _selectedIndex = selectedIndex;
        [self scrollToIndex:selectedIndex];
        [UIView animateWithDuration:0.25
                         animations:^{
                             [selectedBox setCenter:[self centerForIndex:selectedIndex]];
                         }];
    }
}

- (CGPoint)centerForIndex:(NSInteger)index{
    return CGPointMake(66*index+33,35);
}

- (void)scrollToIndex:(NSInteger)index{
    CGFloat offset = [self centerForIndex:index].x - self.frame.size.width/2;
    if (offset>contentView.contentSize.width-contentView.width) {
        offset = contentView.contentSize.width-contentView.width;
    }
    [contentView setContentOffset:CGPointMake(offset>0?offset:0, 0) animated:YES];
}

- (void)ScrollItemListView:(GHScrollItemListView *)listView didSelectItemAtIndex:(NSInteger)index{

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
@end
