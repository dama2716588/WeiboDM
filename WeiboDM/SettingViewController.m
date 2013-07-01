//
//  SettingViewController.m
//  WeiboDM
//
//  Created by ma yulong on 13-6-8.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import "SettingViewController.h"
#import "BrowserViewController.h"
#import "MainViewController.h"
#import "DMNavigationController.h"
#import "DMChecking.h"


@interface SettingViewController ()

@end

@implementation SettingViewController
{
    UITableView *_settingTable;
    PTSinaWeiboClient *_sinaWeiboClient;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _sinaWeiboClient = [[PTSinaWeiboClient alloc] init];
        _sinaWeiboClient.delegate = self;
        self.navigationItem.rightBarButtonItem = nil;        
    }
    return self;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设置";
    
    _settingTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460) style:UITableViewStyleGrouped];
    _settingTable.delegate = self;
    _settingTable.dataSource = self;
    _settingTable.backgroundColor = [UIColor clearColor];
    _settingTable.backgroundView = nil;
    
    [self.view addSubview:_settingTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"setCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"个人资料";
            break;
        case 1:
            cell.textLabel.text = @"退出账号";
            break;
        case 2:
            cell.textLabel.text = @"浏览器";
            break;
        case 3:
            cell.textLabel.text = @"......";
            break;
        case 4:
            cell.textLabel.text = @"......";
            break;
            
        default:
            break;
    }
    
    cell.accessoryType = UITableViewCellSeparatorStyleSingleLine;
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:nil message:@"Are You Sure ?" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
    BrowserViewController *bvc = [[BrowserViewController alloc] initWithURL:@"http:www.baidu.com"];    
    
    switch (indexPath.row) {
        case 0:
            //
            break;
        case 1:
            [alert1 show];
            break;
        case 2:
            [self.navigationController pushViewController:bvc animated:YES];
            break;
        case 3:
            break;
        case 4:
            //
            break;
            
        default:
            break;
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [_sinaWeiboClient logout];
    }
    
    if (buttonIndex == 0) {
        //
    }
}

-(void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    [self showPrompt:@"退出成功" delay:0.8];
        
    double delayInSeconds = 0.8;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        LoginViewController *lvc = [[LoginViewController alloc] init];
        lvc.delegate = self;
        [self.navigationController presentModalViewController:lvc animated:YES];
    });
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

#pragma mark - LoginViewControllerDelegate

-(void)loginViewControllerDone
{
    MainViewController *mvc = [[MainViewController alloc] init];
    DMNavigationController *nv = [[DMNavigationController alloc] initWithRootViewController:mvc];
    [[[UIApplication sharedApplication] keyWindow] setRootViewController:nv];
    [[DMChecking sharedDMChecking] start];
}

@end
