//
// Created by eric on 13-3-22.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"

#define SINA_USER_INFO_PATH      @"users/show.json"
#define SINA_POST_STATUS_PATH    @"statuses/update.json"
#define SINA_HOME_TIMELINE_PATH  @"statuses/home_timeline.json"
#define SINA_ATME_PATH           @"statuses/mentions.json"
#define SINA_WEIBO_SHOW_PATH     @"statuses/show.json"
#define SINA_WEIBO_UPLOAD_PATH   @"statuses/upload.json"
#define SINA_WEIBO_UPDATE_PATH   @"statuses/update.json"
#define SINA_COMMENTS_SHOW_PATH  @"comments/show.json"
#define SINA_UNREAD_COUNG_PATH   @"remind/unread_count.json"
#define SINA_COMMENTS_TOME_PATH  @"comments/to_me.json"
#define SINA_SETCOUNT_PATH       @"remind/set_count.json"
#define SINA_FRIENDS_PATH        @"friendships/friends.json"
#define SINA_FOLLOWERS_PATH      @"friendships/followers.json"
#define SINA_USER_TIMELINE_PATH  @"statuses/user_timeline.json"
#define SINA_COMMENT_AWEIBO_PATH @"comments/create.json"
#define SINA_REPOST_AWEIBO_PATH  @"statuses/repost.json"

#define SINA_FRIENDSHIPS_CREATE             @"friendships/create.json"
#define SINA_FRIENDSHIPS_FRIENDS            @"friendships/friends.json"
#define SINA_FRIENDSHIPS_FRIENDS_BILATERAL  @"friendships/friends/bilateral.json"

#define K_SINA_WEIBO_UID            @"uid"
#define K_SINA_ACCESS_TOKEN         @"access_token"
#define K_SINA_COUNT                @"count"
#define K_SINA_CURSOR               @"cursor"
#define K_SINA_PAGE                 @"page"
#define K_SINA_STATUS               @"status"
#define K_SINA_ERROR_CODE           @"error_code"

@interface PTSinaWeiboClient : NSObject <SinaWeiboDelegate,SinaWeiboRequestDelegate>
@property(strong, nonatomic) SinaWeibo *sinaWeibo;
@property(weak, nonatomic) id <SinaWeiboDelegate> delegate;

- (void)login;

- (void)logout;

@end