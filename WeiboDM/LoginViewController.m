//
//  LoginViewController.m
//  WeiboDM
//
//  Created by ma yulong on 13-5-24.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"

#define BUTTON_HEIGHT 44
#define BUTTON_FRAME CGRectMake(0, 0, 180, BUTTON_HEIGHT)
#define SINA_FRIENDS_GET_PER_PAGE_CNT   @"200"

#define WEI_BO_ID_KEY           @"weibo_id"
#define FRIEND_SHIP_TYPE_KEY    @"friend_type"

@interface LoginViewController ()

@end

@implementation LoginViewController
{
    UIImageView *_imgvButtonsBG;    
}

enum {
    TAG_SINA_BTN = 100,
    TAG_LOOK_AROUND_BTN
};

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _sinaWeiboClient = [[PTSinaWeiboClient alloc] init];
        _sinaWeiboClient.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"登陆";
    
    _imgvButtonsBG = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _imgvButtonsBG.image = [UIImage imageNamed:@"login_bg.png"];
    _imgvButtonsBG.userInteractionEnabled = YES;
    
    self.btnSinaLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnLookAround = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.btnSinaLogin setBackgroundImage:[UIImage imageNamed:@"login_sina_BTN.png"] forState:UIControlStateNormal];
    [self.btnSinaLogin setBackgroundImage:[UIImage imageNamed:@"login_sina_BTN_s.png"] forState:UIControlStateHighlighted];
    
    [self.btnLookAround setBackgroundImage:[UIImage imageNamed:@"login_ignore_BTN.png"] forState:UIControlStateNormal];
    [self.btnLookAround setBackgroundImage:[UIImage imageNamed:@"login_ignore_BTN_s.png"] forState:UIControlStateHighlighted];
    
    _btnSinaLogin.frame = BUTTON_FRAME;
    _btnSinaLogin.tag = TAG_SINA_BTN;
    _btnLookAround.frame = BUTTON_FRAME;
    _btnLookAround.tag = TAG_LOOK_AROUND_BTN;
    
    _btnSinaLogin.center = self.view.center;
    _btnLookAround.center = CGPointMake(160, 150);
    
    [_btnSinaLogin addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_btnLookAround addTarget:self action:@selector(lookAround:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnSinaLogin setTitle:@"微博登录" forState:UIControlStateNormal];
    [_btnLookAround setTitle:@"随便看看" forState:UIControlStateNormal];
    
    [self.view addSubview:_imgvButtonsBG];
    
    [_imgvButtonsBG addSubview:_btnSinaLogin];
    [_imgvButtonsBG addSubview:_btnLookAround];
    
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnClicked:(id)sender
{
    [_sinaWeiboClient login];
}

- (void)lookAround:(id)sender
{
    //
}

- (void)gotoRegisterState{}

#pragma mark SinaWeiboDelegate
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo {
    if (_delegate && [_delegate respondsToSelector:@selector(loginViewControllerDone)]) {
        [_delegate loginViewControllerDone];
    }
}

@end
