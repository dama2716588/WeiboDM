//
//  CommentViewController.m
//  WeiboDM
//
//  Created by ma yulong on 13-6-13.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import "CommentViewController.h"
#import "SinaCommentsModel.h"
#import "MYCommentCell.h"

@interface CommentViewController ()

@end

@implementation CommentViewController
{
    PTSinaWeiboClient *_sinaWeiboClient;
    NSMutableArray *commentsArray;
    UITableView *_commentTable;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _sinaWeiboClient = [[PTSinaWeiboClient alloc] init];
        _sinaWeiboClient.delegate = self;
        commentsArray = [[NSMutableArray alloc] init];
        [self getCommemts];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"评论";

    _commentTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.height) style:UITableViewStylePlain];
    _commentTable.delegate = self;
    _commentTable.dataSource = self;
    _commentTable.backgroundColor = [UIColor clearColor];
    _commentTable.backgroundView = nil;
    _commentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_commentTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getCommemts
{
    SinaWeibo *sinaWeibo = _sinaWeiboClient.sinaWeibo;
    NSString *accessToken = sinaWeibo.accessToken;    
    [sinaWeibo requestWithURL:SINA_COMMENTS_TOME_PATH params:[@{@"access_token":accessToken} mutableCopy] httpMethod:@"GET" delegate:self];
}

-(void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    //
}

-(void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    NSLog(@"commemts_result : %@",result);
    
    for (NSDictionary *dic in [result objectForKey:@"comments"]) {
        SinaCommentsModel *model = [[SinaCommentsModel alloc] initWithDictionary:dic];
        [commentsArray addObject:model];
    }
    
    NSLog(@"commentsArray : %@",commentsArray);
    
    [_commentTable reloadData];
    [_commentTable setContentSize:CGSizeMake(_commentTable.contentSize.width, _commentTable.contentSize.height + 50)];    
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return commentsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MYCommentCell heightForCell:[commentsArray objectAtIndex:indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *commentCellId = @"commentCell";
    
    MYCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellId];
    
    if (!cell) {
        cell  = [[MYCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentCellId];
    }
        [cell updateDataWith:[commentsArray objectAtIndex:indexPath.row]];
    
    return cell;
}

@end
