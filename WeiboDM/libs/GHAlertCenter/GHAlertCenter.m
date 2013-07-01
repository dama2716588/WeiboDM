//
//  GHAlertCenter.m
//  notebook
//
//  Created by 诗彬 刘 on 12-6-6.
//  Copyright (c) 2012年 ifuninfo. All rights reserved.
//

#import "GHAlertCenter.h"
#import "SynthesizeSingleton.h"

@implementation GHAlertView
@synthesize confirmAction,action,dismissAction;
@synthesize identifier;

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

+ (void)alertWithTitle:(NSString *)title tip:(NSString *)tip type:(GHAlertType)type action:(GHSimpleAction)action dismissAction:(GHSimpleAction)dismissAction
{
    GHAlertView *alert = [[GHAlertView alloc] initWithTitle:title tip:tip type:type confirmAction:action dismissAction:dismissAction];
    [alert show];
}

+ (void)alertWithTitle:(NSString *)title tip:(NSString *)tip type:(GHAlertType)type action:(GHSimpleAction)action{
    return [GHAlertView alertWithTitle:title tip:tip type:type action:action dismissAction:nil];
}

- (id)initWithTitle:(NSString *)title tip:(NSString *)tip type:(GHAlertType)type{
    return [self initWithTitle:title tip:tip type:type confirmAction:nil];
}

- (id)initWithTitle:(NSString *)title tip:(NSString *)tip type:(GHAlertType)type confirmAction:(GHSimpleAction)anAction dismissAction:(GHSimpleAction)aDismissAction
{
    self = [self init];
    if (self) {
        self.frame = CGRectMake(0, 0, 314, 180);
        UIImage *bgImage =[[UIImage imageNamed:@"bg_dingyuechenggong.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:12];
        UIImageView *bg = [[UIImageView alloc] initWithImage:bgImage];
        bg.tag = 10;
        bg.frame = CGRectMake(0, 0, 314, 129);
        [self addSubview:bg];
        bg.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(37, 10, 240, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.textColor= [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        titleLabel.font = [UIFont systemFontOfSize:18.0f];
        titleLabel.contentMode = UIViewContentModeCenter;
        titleLabel.numberOfLines = 0;
        titleLabel.tag = 11;
        titleLabel.text = title;
        [self addSubview:titleLabel];
        
        //Modify by Eric
        //        CGSize size = [tip sizeWithFont:[UIFont systemFontOfSize:16.0f]
        //                      constrainedToSize:CGSizeMake(240, 1000)];
        CGSize size = [tip sizeWithFont:[UIFont systemFontOfSize:16.0f]
                      constrainedToSize:CGSizeMake(260, 1000)];
        CGFloat height = MAX(50.0f, size.height);
        
        CGFloat d = height - 50;
        self.height += d;
        
        //        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(37, 50, 240,height)];
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(27, 50, 260,height)];
        
        if (title == nil) {
            [textLabel setFrame:CGRectMake(27, 40, 260, height)];
        }
        
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textAlignment = UITextAlignmentCenter;
        textLabel.textColor= [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        textLabel.font = [UIFont systemFontOfSize:16.0f];
        textLabel.contentMode = UIViewContentModeCenter;
        textLabel.numberOfLines = 0;
        textLabel.text = tip;
        [self addSubview:textLabel];
        
        if (type == GHAlertTypeConfirm) {
            confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [confirmBtn setBackgroundImage:[UIImage imageNamed:@"ok_btn"] forState:UIControlStateNormal];
            [confirmBtn setBackgroundImage:[UIImage imageNamed:@"ok_btns"] forState:UIControlStateHighlighted];
            [confirmBtn sizeToFit];
            [confirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
            confirmBtn.center = CGPointMake(self.width/2 - 50, 160 + d);
            confirmBtn.exclusiveTouch = YES;
            [self addSubview:confirmBtn];
            
            cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [cancelBtn setBackgroundImage:[UIImage imageNamed:@"cancle_btn"] forState:UIControlStateNormal];
            [cancelBtn setBackgroundImage:[UIImage imageNamed:@"cancle_btns"] forState:UIControlStateHighlighted];
            [cancelBtn sizeToFit];
            [cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
            cancelBtn.exclusiveTouch = YES;
            cancelBtn.center = CGPointMake(self.width/2 + 50, 160 + d);
            [self addSubview:cancelBtn];
            
            self.confirmAction = anAction;
            self.dismissAction = aDismissAction;
        }else if(type == GHAlertTypeTip){
            [self performSelector:@selector(cancel:) withObject:nil afterDelay:2];
        }else if(type == GHAlertTypeLoding){
            indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            indicator.center = CGPointMake(self.width/2, 70 + d/2);
            indicator.tag = 12;
            [self addSubview:indicator];
            [indicator startAnimating];
        }else if(type == GHAlertTypeConfirmTip){
            
            confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [confirmBtn setBackgroundImage:[UIImage imageNamed:@"ok_btn"] forState:UIControlStateNormal];
            [confirmBtn setBackgroundImage:[UIImage imageNamed:@"ok_btns"] forState:UIControlStateHighlighted];
            [confirmBtn sizeToFit];
            [confirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
            confirmBtn.center = CGPointMake(self.width/2 , 160 + d);
            confirmBtn.exclusiveTouch = YES;
            [self addSubview:confirmBtn];
            
            self.confirmAction = anAction;
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)orientationChanged:(NSNotification *)notification
{
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (statusBarOrientation == UIDeviceOrientationLandscapeLeft || statusBarOrientation == UIDeviceOrientationLandscapeRight) {
        [UIView animateWithDuration:0.4 animations:^{
            [self setFrame:CGRectMake((1024-self.width)/2, (768 - self.height) / 2  + 60, self.width, self.height)];
        }];
    } else {
        [UIView animateWithDuration:0.4 animations:^{
            [self setFrame:CGRectMake((768-self.width)/2, (1024 - self.width) / 2, self.width, self.height)];
        }];
    }
}

- (id)initWithTitle:(NSString *)title tip:(NSString *)tip type:(GHAlertType)type confirmAction:(GHSimpleAction)anAction {
    return [self initWithTitle:title tip:tip type:type confirmAction:anAction dismissAction:nil];
}

- (void)confirm:(id)sender{
    if (confirmAction) {
        [self performBlockOnMainThread:confirmAction waitUntilDone:YES];
    }
    [self dismissAnimated:YES];
}

- (void)cancel:(id)sender{
    if (dismissAction) {
        [self performBlockOnMainThread:dismissAction waitUntilDone:YES];
    }
    [self dismissAnimated:YES];
}

- (void)show{
    [[GHAlertCenter sharedGHAlertCenter] showAlert:self];
}

- (void)dismissAnimated:(BOOL)animated{
    [[GHAlertCenter sharedGHAlertCenter] dismissAlert:self animated:animated];
}
@end

@implementation GHAlertCenter
SYNTHESIZE_SINGLETON_FOR_CLASS(GHAlertCenter);

-(void)showAlert:(GHAlertView *)alert{
    if (!alerts) {
        alerts = [[NSMutableArray alloc] init];
    }
    if (![alerts containsObject:alert]) {
        [alerts addObject:alert];
    }
    window =  [[UIApplication sharedApplication] keyWindow].rootViewController.view;
    if (!maskView) {
        maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 1024)];
        [maskView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];

        [maskView setBackgroundColor:[UIColor blackColor]];
        maskView.alpha = 0.3;
    }
    if (alerts.count == 1) {
        [window addSubview:maskView];
    }    
    
    alert.frame =  CGRectMake((window.width-alert.width)/2, (window.height - alert.height) / 2, alert.width, alert.height);

    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (statusBarOrientation == UIDeviceOrientationLandscapeLeft || statusBarOrientation == UIDeviceOrientationLandscapeRight) {
        alert.frame = CGRectMake((1024-alert.width)/2, (768 - alert.height) / 2 + 60, alert.width, alert.height);
    } else {
        alert.frame = CGRectMake((768-alert.width)/2, (1024 - alert.height) / 2, alert.width, alert.height);
    }
    
//    alert.center = window.centerOfView;
    [window addSubview:alert];
    
    alert.transform = CGAffineTransformMakeScale(0.001, 0.001);
    [UIView animateWithDuration:0.3/1.5 
                     animations:^{
                         alert.transform = CGAffineTransformMakeScale(1.1, 1.1);
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.3/2
                                          animations:^{
                                              alert.transform = CGAffineTransformMakeScale(0.9, 0.9);
                                          }
                                          completion:^(BOOL finished) {
                                              [UIView animateWithDuration:0.3/2
                                                               animations:^{
                                                                   alert.transform = CGAffineTransformIdentity;
                                                               }];
                                          }]; 
                     }];
}

-(void)dismissAlert:(GHAlertView *)alert animated:(BOOL)animated{
    [alerts removeObject:alert];
    [UIView animateWithDuration:animated?0.3:0.01
                     animations:^{
                         alert.alpha = 0;
                         if (alerts.count == 0) {
                             maskView.alpha = 0;
                         }
                     } 
                     completion:^(BOOL finished) {
                         [alert removeFromSuperview];
                         if (alerts.count == 0) {
                             [maskView removeFromSuperview];
                         }
                         maskView.alpha = 0.3;
                     }];
}

-(GHAlertView *)alertWithIdentifier:(NSString *)identifier{
    for (GHAlertView *alert in alerts) {
        if ([alert.identifier isEqualToString:identifier]) {
            return alert;
        }       
    }
    return nil;
}

+(void)taskWithAlert:(NSString *)tip task:(void(^)(void))task finish:(void(^)(void))finish{
    GHAlertView *alert = [[GHAlertView alloc] initWithTitle:tip tip:nil type:GHAlertTypeLoding];
    [alert show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        if (task) {
            task();
        }
        [NSThread sleepForTimeInterval:0.3];
        dispatch_async(dispatch_get_main_queue(),^{
            [alert dismissAnimated:YES];
            if (finish) {
                finish();   
            }
        });
    }
                   );
}

@end
