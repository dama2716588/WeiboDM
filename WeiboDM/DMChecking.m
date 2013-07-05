//
//  DMChecking.m
//  WeiboDM
//
//  Created by ma yulong on 13-6-11.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import "DMChecking.h"

#define MONITOR_LOOP_INTERVAL       15

@implementation DMChecking
{
    BOOL _stopped;
    int _current;
    NSOperationQueue *_monitorQueue;
    PTSinaWeiboClient *_sinaWeiboClient;
}

SYNTHESIZE_SINGLETON_FOR_CLASS(DMChecking)

- (void)dealloc {
    _monitorQueue = nil;
    _sinaWeiboClient = nil;
}

-(id)init
{
    if (self = [super init]) {
        
        _monitorQueue = [[NSOperationQueue alloc] init];
        _monitorQueue.maxConcurrentOperationCount = 1;
        _current = 0;
        _stopped = YES;
        
        NSBlockOperation *main = [NSBlockOperation blockOperationWithBlock:^{
           
            while (YES) {
                
                if (_stopped) {
                    NSLog(@"checking is stopped");
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(), ^() {  //可能会遇到主线程阻塞的情况
                        NSLog(@"checking ......");
                        [self getUnreadCount];
                        
                    });                    
                }
                
                NSLog(@"sleep for %d seconds", MONITOR_LOOP_INTERVAL);
                [NSThread sleepForTimeInterval:MONITOR_LOOP_INTERVAL];
            }
        }];
        
        [_monitorQueue addOperation:main];                
    }
    
    return self;
}

- (void)getUnreadCount
{
    if (!_sinaWeiboClient) {
        _sinaWeiboClient = [[PTSinaWeiboClient alloc] init];
        _sinaWeiboClient.delegate = self;
    }
    
    SinaWeibo *sinaWeibo = _sinaWeiboClient.sinaWeibo;
    
    if (![sinaWeibo isLoggedIn]) {
        _stopped = YES;
        NSLog(@"user is not login");
        return;
    } else {
        _stopped = NO;
    }
    
    NSString *accessToken = sinaWeibo.accessToken;
    NSString *userId = sinaWeibo.userID;
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setValue:accessToken forKey:@"access_token"];
    [paramsDic setValue:userId forKey:@"uid"];
    
    [sinaWeibo requestWithURL:SINA_UNREAD_COUNG_PATH params:paramsDic
                   httpMethod:@"GET" delegate:self];
    
}

- (void)start {
    _stopped = NO;
}

- (void)stop {
    _stopped = YES;
}


#pragma mark - SinaWeiboRequestDelegate

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    NSLog(@"allWeibo_unreadCount : %@",result);
    
    dispatch_async(dispatch_get_main_queue(), ^() {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHECKING_UNREAD_COUNT"
                                                            object:self
                                                          userInfo:result];
    });
    
}

-(void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"get sinaweibo failed %@",error);
}

@end
