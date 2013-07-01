//
//  SinaWeiboAuthorizeView.h
//  sinaweibo_ios_sdk
//
//  Created by Wade Cheng on 4/19/12.
//  Copyright (c) 2012 SINA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@protocol SinaWeiboAuthorizeViewDelegate;

@interface SinaWeiboAuthorizeView : UIView <UIWebViewDelegate> {
    UIWebView *webView;
    UIImageView *whiteBGImageView;
    UIButton *closeButton;
    UIView *modalBackgroundView;
    UIActivityIndicatorView *indicatorView;
    UIInterfaceOrientation previousOrientation;

    id <SinaWeiboAuthorizeViewDelegate> delegate;

    NSString *appRedirectURI;
    NSDictionary *authParams;
}

@property(nonatomic, assign) id <SinaWeiboAuthorizeViewDelegate> delegate;

- (id)initWithAuthParams:(NSDictionary *)params
                delegate:(id <SinaWeiboAuthorizeViewDelegate>)delegate;

- (void)show;

- (void)hide;

- (void)cancel;

@end

@protocol SinaWeiboAuthorizeViewDelegate <NSObject>

- (void)      authorizeView:(SinaWeiboAuthorizeView *)authView
didRecieveAuthorizationCode:(NSString *)code;

- (void)authorizeView:(SinaWeiboAuthorizeView *)authView
 didFailWithErrorInfo:(NSDictionary *)errorInfo;

- (void)authorizeViewDidCancel:(SinaWeiboAuthorizeView *)authView;

@end