//
//  NotifyView.h
//  WeiboDM
//
//  Created by ma yulong on 13-6-12.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotifyView : UIView
{
    BOOL           _isCountShow;    
    UILabel        *_countLabel;
    UIImageView    *_countImageView;
    UIButton       *_mainButton;
    UIButton       *_statusButton;
}

- (id)initWithTarget:(id)target action:(SEL)action;
- (void)setBadgeCount:(NSInteger)count;

@end
