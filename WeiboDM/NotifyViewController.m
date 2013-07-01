//
//  NotifyViewController.m
//  WeiboDM
//
//  Created by ma yulong on 13-6-12.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import "NotifyViewController.h"
#import "CommentViewController.h"
#import "SinaWeiboType.h"
#import "MainViewController.h"
#import "SettingViewController.h"
#import "FriendViewController.h"

enum
{
    ICON_IMAGE_TAG = 100,
    NUM_BUTTON_TAG,
    TEXT_LABEL_TAG,
    LINE_VIEW_TAG,
};

@interface NotifyViewController ()

@end

@implementation NotifyViewController
{
    NSDictionary *notifyDic;
    UITableView *_notifyTable;
    PTSinaWeiboClient *_sinaWeiboClient;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor colorWithRed:237/255.0f green:237/255.0f blue:237/255.0f alpha:0.9];
        _sinaWeiboClient = [[PTSinaWeiboClient alloc] init];
        _sinaWeiboClient.delegate = self;
    }
    return self;
}

- (id)initWithNotify:(NSDictionary *)dic
{
    if (self = [super init]) {        
        notifyDic = dic;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"消息";

    _notifyTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460) style:UITableViewStylePlain];
    _notifyTable.delegate = self;
    _notifyTable.dataSource = self;
    _notifyTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _notifyTable.separatorColor = [UIColor lightGrayColor];
    _notifyTable.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_notifyTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"notifyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    UIImageView *iconImage;
    UIButton *numButton;
    UILabel *textLabel;
    UIView *lineView;
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        iconImage.tag = ICON_IMAGE_TAG;
        numButton = [UIButton buttonWithType:UIButtonTypeCustom];
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 100, 40)];
        textLabel.tag = TEXT_LABEL_TAG;
        numButton.frame = CGRectMake(260, 20, 20, 20);
        numButton.tag = NUM_BUTTON_TAG;
        lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, 320, 1)];
        lineView.tag = LINE_VIEW_TAG;
        
        [cell addSubview:iconImage];
        [cell addSubview:numButton];
        [cell addSubview:textLabel];
        [cell addSubview:lineView];        
    } else {
        iconImage = (UIImageView *)[cell viewWithTag:ICON_IMAGE_TAG];
        numButton = (UIButton *)[cell viewWithTag:NUM_BUTTON_TAG];
        textLabel = (UILabel *)[cell viewWithTag:TEXT_LABEL_TAG];
        lineView = (UIView *)[cell viewWithTag:LINE_VIEW_TAG];
    }
    
    numButton.backgroundColor = [UIColor clearColor];
    numButton.layer.cornerRadius = 10;
    numButton.clipsToBounds = YES;
    [numButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    lineView.backgroundColor = [UIColor lightGrayColor];
    textLabel.backgroundColor = [UIColor clearColor];
    iconImage.image = [UIImage imageNamed:@"pinglun_big_icon"];
    
    switch (indexPath.row) {
        case 0:
            textLabel.text = @"评论";
            [numButton setTitle: [[notifyDic objectForKey:@"cmt"] integerValue] > 0 ? [[notifyDic objectForKey:@"cmt"] description] : nil forState:UIControlStateNormal];
            break;
        case 1:
            [numButton setTitle: [[notifyDic objectForKey:@"mention_status"] integerValue] > 0 ? [[notifyDic objectForKey:@"mention_status"] description] : nil forState:UIControlStateNormal];
            textLabel.text = @"@我";
            break;
        case 2:
            textLabel.text = @"粉丝";
            [numButton setTitle: [[notifyDic objectForKey:@"follower"] integerValue] > 0 ? [[notifyDic objectForKey:@"follower"] description] : nil forState:UIControlStateNormal];
            break;
        case 3:
            textLabel.text = @"设置";
            break;
        default:
            break;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self setReadCount:@"cmt"];        
        CommentViewController *cvc = [[CommentViewController alloc] init];
        [self.navigationController pushViewController:cvc animated:YES];
    }
    
    if (indexPath.row == 1) {
        [self setReadCount:@"mention_status"];
        SinaWeiboType *type = [[[DataCenter sharedDataCenter] getSinaWeiboTypeList] objectAtIndex:5];
        MainViewController *mvc = [[MainViewController alloc] initWithType:type];
        mvc.title = @"@我的";
        [self.navigationController pushViewController:mvc animated:YES];
    }
    
    if (indexPath.row == 2) {
        [self setReadCount:@"follower"];
        FriendViewController *fvc = [[FriendViewController alloc] initWithFriendType:@"followers"];
        [self.navigationController pushViewController:fvc animated:YES];
    }
    
    if (indexPath.row == 3) {
        SettingViewController *svc = [[SettingViewController alloc] init];
        [self.navigationController pushViewController:svc animated:YES];
    }
}

- (void)setReadCount:(NSString *)type
{
    SinaWeibo *sinaWeibo = _sinaWeiboClient.sinaWeibo;
    NSString *accessToken = sinaWeibo.accessToken;
    [sinaWeibo requestWithURL:SINA_SETCOUNT_PATH params:[@{@"access_token":accessToken,@"type":type} mutableCopy]
                   httpMethod:@"GET" delegate:self];
}

-(void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    //
}

-(void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([request.url hasSuffix:SINA_SETCOUNT_PATH]) {
        if ([[result  objectForKey:@"result"] boolValue] == true) {
            NSLog(@"set_count success!");
        } else {
            NSLog(@"result_error : %@",result);
        }        
    }
}

@end
