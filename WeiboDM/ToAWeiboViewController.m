//
//  ToAWeiboViewController.m
//  WeiboDM
//
//  Created by ma yulong on 13-6-19.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import "ToAWeiboViewController.h"

NSString *const RELOAD_COMMENT_TABLE = @"RELOAD_COMMENT_TABLE";

@interface ToAWeiboViewController ()

@end

@implementation ToAWeiboViewController
{
    ResponseWeiboType _type;
    SinaWeiboModel *_model;
    UITextView *_sendTextView;
    UIButton *_leftButton;
    UIButton *_rightButton;
    PTSinaWeiboClient *_sinaWeiboClient;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithType:(ResponseWeiboType)type andModel:(SinaWeiboModel *)model
{
    if (self = [super init]) {
        _type = type;
        _model = model;
        _sinaWeiboClient = [[PTSinaWeiboClient alloc] init];
        _sinaWeiboClient.delegate = self;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = _type == CommentType ? @"评论微博" : @"转发微博";
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 7, 40, 30);
    [_leftButton setTitle:@"取消" forState:UIControlStateNormal];
    _leftButton.titleLabel.font = T12_FONT;
    _leftButton.layer.cornerRadius = 2;
    [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_leftButton setBackgroundColor:[UIColor grayColor]];
    [_leftButton addTarget:self action:@selector(cancelSend:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftButton];
	
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(0, 7, 40, 30);
    [_rightButton setTitle:@"发送" forState:UIControlStateNormal];
    _rightButton.titleLabel.font = T12_FONT;
    _rightButton.layer.cornerRadius = 2;
    [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightButton setBackgroundColor:[UIColor grayColor]];
    [_rightButton addTarget:self action:@selector(doSend:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];    
    
    _sendTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    _sendTextView.delegate = self;
    _sendTextView.font = T14_FONT;
    _sendTextView.keyboardType = UIKeyboardTypeDefault;
    _sendTextView.inputView = nil;
    [_sendTextView becomeFirstResponder];
    
    if (_type == RepostType) {
        
        NSString *textStr;
        
        if (!_model.sinaRepost) {
           textStr = [NSString stringWithFormat:@"//@%@:%@",_model.sinaUser.name,_model.text];
        } else {
            textStr = [NSString stringWithFormat:@"//@%@:%@//@%@:%@",_model.sinaUser.name,_model.text,_model.sinaRepost.sinaUser.name,_model.sinaRepost.text];
            if(textStr.length > 160) textStr = [textStr substringToIndex:160];
        }
        
        CGSize size = [textStr sizeWithFont:T12_FONT
                              constrainedToSize:CGSizeMake(300, 200)
                                  lineBreakMode:UILineBreakModeWordWrap];
        UILabel *commLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 300, size.height+GAP_20)];
        commLabel.numberOfLines = 0;
        commLabel.font = T12_FONT;
        commLabel.backgroundColor = [UIColor colorWithRed:237/255.0f green:237/255.0f blue:237/255.0f alpha:0.9];
        commLabel.text = [NSString stringWithFormat:@"微博来自%@:%@",_model.sinaUser.name,_model.text];
        [self.view addSubview:commLabel];
        
    } else {
        
        CGSize size = [_model.text sizeWithFont:T12_FONT
                      constrainedToSize:CGSizeMake(300, 200)
                          lineBreakMode:UILineBreakModeWordWrap];                
        UILabel *commLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 300, size.height+GAP_20)];
        commLabel.numberOfLines = 0;
        commLabel.font = T12_FONT;
        commLabel.backgroundColor = [UIColor colorWithRed:237/255.0f green:237/255.0f blue:237/255.0f alpha:0.9];
        commLabel.text = [NSString stringWithFormat:@"微博来自%@:%@",_model.sinaUser.name,_model.text];
        [self.view addSubview:commLabel];
    }
    
    [self.view addSubview:_sendTextView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelSend:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
    NSLog(@"%d  %d  %@ %@",range.location,range.length, text, [textView text]);
    
    if ( [text isEqualToString:@"\n"] ) {
        return NO;
    }
    return YES;
}

- (void)doSend:(id)sender
{
    [_sendTextView resignFirstResponder];
    
    SinaWeibo *sinaWeibo = _sinaWeiboClient.sinaWeibo;
    NSString *accessToken = sinaWeibo.accessToken;
    NSString *weiboId = _model.mid;
    NSString *content = _sendTextView.text;
    NSLog(@"weiboid___ : %@",weiboId);
    
    if (_type == CommentType) {
        [sinaWeibo requestWithURL:SINA_COMMENT_AWEIBO_PATH
                           params:[@{@"access_token":accessToken,@"comment":content,@"id":weiboId} mutableCopy]
                       httpMethod:@"POST"
                         delegate:self];
    }
    
    if (_type == RepostType) {
        [sinaWeibo requestWithURL:SINA_REPOST_AWEIBO_PATH
                           params:[@{@"access_token":accessToken,@"status":content,@"id":weiboId} mutableCopy]
                       httpMethod:@"POST"
                         delegate:self];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];        
}

- (void)showPrompt:(NSString *)prompt delay:(NSTimeInterval)delay
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (prompt.length > 14) {
        hud.labelFont = [UIFont systemFontOfSize:13];
    }
    hud.mode = MBProgressHUDModeText;
    hud.labelText = prompt;
    hud.yOffset = (self.navigationController.view ? 0 : -32);
    [hud hide:YES afterDelay:delay];
}

#pragma mark - SinaWeiboRequestDelegate

-(void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"send_weibo_error : %@",error);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self showPrompt:@"发布失败" delay:0.8];
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    NSLog(@"send_weibo_result : %@",result);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    if ([[result objectForKey:@"error_code"] intValue] == 20101 ) {
       [self showPrompt:@"微博不存在" delay:0.8];
    } else if ([result objectForKey:@"error"]){
       [self showPrompt:@"发布失败" delay:0.8];
    } else {
       [self showPrompt:@"发布成功" delay:0.8];        
    }
    
    double delayInSeconds = 0.6;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
       [self dismissModalViewControllerAnimated:YES];
        
        if (_type == CommentType) {
            [[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_COMMENT_TABLE
                                                                object:self
                                                              userInfo:nil];
        }
        
    });
    
}

@end
