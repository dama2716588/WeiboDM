//
//  DMStatusBar.m
//  WeiboDM
//
//  Created by ma yulong on 13-6-18.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import "DMStatusBar.h"

@implementation DMStatusBar

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelNormal;
        self.windowLevel = UIWindowLevelStatusBar + 1.0f;
		self.frame = frame;
        self.backgroundColor = [UIColor blackColor];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 70, 20)];
        _textLabel.backgroundColor = [UIColor blackColor];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = [UIFont systemFontOfSize:10.0f];
        _textLabel.textAlignment = UITextAlignmentLeft;
        _textLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshMain:)];
        [_textLabel addGestureRecognizer:tap];
        [self addSubview:_textLabel];        
        
        _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_statusButton setFrame:CGRectMake(10, 2, 16, 16)];
        [_statusButton setBackgroundImage:[UIImage imageNamed:@"status_baloon"] forState:UIControlStateNormal];
        [_statusButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_statusButton];
        
        self.hidden = YES;
        _statusButton.hidden = YES;
    }
    return self;
}

- (void)refreshMain:(UITapGestureRecognizer *)tap
{
    dispatch_async(dispatch_get_main_queue(), ^() {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GET_UNREAD_WEIBO"
                                                            object:self
                                                          userInfo:nil];
    });    
}

- (void)clickButton:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^() {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GET_UNREAD_WEIBO"
                                                            object:self
                                                          userInfo:nil];
    });    
}

- (void)showStatusMessage:(NSString *)message{            
    [UIView animateWithDuration:0.5f animations:^{
        self.hidden = NO;
        self.alpha = 1.0f;
    } completion:^(BOOL finished){
        _textLabel.text = message;
        _statusButton.hidden = NO;
    }];
}

- (void)hide{
    self.alpha = 1.0f;
    
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished){
        _textLabel.text = @"";
        _statusButton.hidden = YES;
        self.hidden = YES;
    }];;
    
}



@end
