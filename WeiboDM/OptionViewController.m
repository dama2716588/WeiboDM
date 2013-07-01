//
//  OptionViewController.m
//  WeiboDM
//
//  Created by ma yulong on 13-6-7.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import "OptionViewController.h"
#import "PTSinaWeiboClient.h"

@interface OptionViewController ()

@end

@implementation OptionViewController
{
    PTSinaWeiboClient *_sinaWeiboClient;    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _sinaWeiboClient = [[PTSinaWeiboClient alloc] init];
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
            
    double delayInSeconds = 1.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (!_sinaWeiboClient.sinaWeibo.isAuthValid) {
            if (_delegate && [_delegate respondsToSelector:@selector(navigateToLoginStateView)]) {
                [_delegate navigateToLoginStateView];
            }
        } else {
            if (_delegate && [_delegate respondsToSelector:@selector(navigateToMainStateView)]) {
                [_delegate navigateToMainStateView];
            }
        }        
    });    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_bg.png"]];
    bgImageView.frame = self.view.bounds;
    [self.view addSubview:bgImageView];    
    
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    loadingView.center = CGPointMake(self.view.width / 2.0, self.view.height / 2.0);
    loadingView.tag = 1000;
    [loadingView startAnimating];
    [bgImageView addSubview:loadingView];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
