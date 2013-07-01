//
//  GHAlertCenter.h
//  notebook
//
//  Created by 诗彬 刘 on 12-6-6.
//  Copyright (c) 2012年 ifuninfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^GHSimpleAction)();

typedef enum{
    GHAlertTypeLoding = 1,
    GHAlertTypeConfirm,
    GHAlertTypeTip,
    GHAlertTypeConfirmTip
}GHAlertType;

@interface GHAlertView : UIView{
    UILabel *titleLabel;
    UILabel *textLabel;
    UIActivityIndicatorView *indicator;
    UIImageView *imageView;
    UIButton *confirmBtn;
    UIButton *cancelBtn;
}
@property(nonatomic,copy)GHSimpleAction confirmAction;
@property(nonatomic,copy)GHSimpleAction dismissAction;
@property(nonatomic,copy)GHSimpleAction action;
@property(nonatomic,copy)NSString *identifier;
- (id)initWithTitle:(NSString *)title tip:(NSString *)tip type:(GHAlertType)type confirmAction:(GHSimpleAction)anAction dismissAction:(GHSimpleAction)aDismissAction;
- (id)initWithTitle:(NSString *)title tip:(NSString *)tip type:(GHAlertType)type confirmAction:(GHSimpleAction)anAction;
- (id)initWithTitle:(NSString *)title tip:(NSString *)tip type:(GHAlertType)type;
+ (void)alertWithTitle:(NSString *)title tip:(NSString *)tip type:(GHAlertType)type action:(GHSimpleAction)action;
+ (void)alertWithTitle:(NSString *)title tip:(NSString *)tip type:(GHAlertType)type action:(GHSimpleAction)action dismissAction:(GHSimpleAction)dismissAction;
- (void)show;
- (void)dismissAnimated:(BOOL)animated;
@end

@interface GHAlertCenter : NSObject{
    UIView *maskView;
    NSMutableArray *alerts;
    UIView *window;
}
+(GHAlertCenter *)sharedGHAlertCenter;
+(void)taskWithAlert:(NSString *)tip task:(void(^)(void))task finish:(void(^)(void))finish;
-(GHAlertView *)alertWithIdentifier:(NSString *)identifier;
-(void)showAlert:(GHAlertView *)alert;
-(void)dismissAlert:(GHAlertView *)alert animated:(BOOL)animated;
@end
