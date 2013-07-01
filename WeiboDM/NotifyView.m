//
//  NotifyView.m
//  WeiboDM
//
//  Created by ma yulong on 13-6-12.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import "NotifyView.h"

@implementation NotifyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTarget:(id)target action:(SEL)action
{
    self = [self initWithFrame:CGRectZero];
    if (self != nil)
    {
        _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_statusButton setFrame:CGRectMake(0, 0, 25, 25)];
        [_statusButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [self setFrame:CGRectMake(0, 0, 25, 25)];
        [self addSubview:_statusButton];        
    }
    return self;
}

- (void)setBadgeCount:(NSInteger)count
{
    if (count == 0)
    {
        [_statusButton setBackgroundImage:[UIImage imageNamed:@"mall_cart_null.png"] forState:UIControlStateNormal];
        [_statusButton setBackgroundImage:[UIImage imageNamed:@"mall_cart_null_down.png"] forState:UIControlStateHighlighted];
    } else {
        
        [_statusButton setBackgroundImage:[UIImage imageNamed:@"mall_cart_not_null.png"] forState:UIControlStateNormal];
        [_statusButton setBackgroundImage:[UIImage imageNamed:@"mall_cart_not_null_down.png"] forState:UIControlStateHighlighted];        
    }    
}

@end
