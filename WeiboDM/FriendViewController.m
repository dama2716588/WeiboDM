//
//  FriendViewController.m
//  WeiboDM
//
//  Created by ma yulong on 13-6-14.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import "FriendViewController.h"
#import "SinaUserModel.h"
#import "FriendCell.h"

@interface FriendViewController ()

@end

@implementation FriendViewController
{
    NSString *_friendType;
    PTSinaWeiboClient *_sinaWeiboClient;
    int _cursor;
    NSMutableArray *usersArray;
    UITableView *_friendTable;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithFriendType:(NSString *)type
{
    if (self = [super init]) {
        _friendType = type;
        _sinaWeiboClient = [[PTSinaWeiboClient alloc] init];
        _sinaWeiboClient.delegate = self;
        usersArray = [NSMutableArray array];
        _cursor = 1;
        [self getFriendsList];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [_friendType isEqualToString:@"friends"] ? @"我的关注" : @"我的粉丝";
    
    _friendTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _friendTable.delegate = self;
    _friendTable.dataSource = self;
    _friendTable.backgroundView = nil;
    _friendTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_friendTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getFriendsList
{
    NSString *url;
    if ([_friendType isEqualToString:@"friends"]) {
        url = SINA_FRIENDS_PATH;
    }
    
    if ([_friendType isEqualToString:@"followers"]) {
        url = SINA_FOLLOWERS_PATH;
    }
    
    SinaWeibo *sinaWeibo = _sinaWeiboClient.sinaWeibo;
    NSString *accessToken = sinaWeibo.accessToken;
    [sinaWeibo requestWithURL:url params:[@{@"access_token":accessToken,@"uid":sinaWeibo.userID} mutableCopy] httpMethod:@"GET" delegate:self];
}

-(void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    //
}

-(void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    NSLog(@"friends_result : %@",result);
    
    for (NSDictionary *dic in [result objectForKey:@"users"]) {
        SinaUserModel *model = [[SinaUserModel alloc] initWithDictionary:dic];
        [usersArray addObject:model];
    }
    
    NSLog(@"usersArray : %@",usersArray);
    
    [_friendTable reloadData];    
    [_friendTable setContentSize:CGSizeMake(_friendTable.contentSize.width, _friendTable.contentSize.height + 50)];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return usersArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"friendCell";
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[FriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    [cell updateDataWith:[usersArray objectAtIndex:indexPath.row]];
    
    return cell;
}

@end
