//
//  BaseViewController.h
//  WeiboDM
//
//  Created by ma yulong on 13-5-24.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwesomeMenu.h"

@interface BaseViewController : UIViewController <AwesomeMenuDelegate>
{
    AwesomeMenu *_menu;
    UISwipeGestureRecognizer *_swipeRecognizerLeft;    
}

- (void)createAwesomeMenuAbove:(UIView *)aView;
- (void)addRightGes:(UIView *)aView;
@end
