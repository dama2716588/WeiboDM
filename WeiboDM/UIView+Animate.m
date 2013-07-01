//
//  UIView+Animate.m
//  WeiboDM
//
//  Created by ma yulong on 13-6-7.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import "UIView+Animate.h"

@implementation UIView (Animate)

-(void)setHiddenAnimated:(BOOL)hide andAlpha:(CGFloat)alpha
{
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^
     {
         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
         if (hide)
             self.alpha=0;
         else
         {
             self.hidden= NO;
             self.alpha=alpha;
         }
     }
                     completion:^(BOOL b)
     {
         if (hide)
             self.hidden= YES;
     }
     ];
}

@end
