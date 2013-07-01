//
// Created by eric on 13-3-22.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PTSinaWeiboClient.h"

#define kAppKey             @"2210025590"
#define kAppSecret          @"38057288ae08fbcae0e79a2e85a8a258"
#define kAppRedirectURI     @"http://weibo.pento.cn"

#define SINA_WEIBO_AUTH_DATA @"SinaWeiboAuthData"

#define KEY_ACCESS_TOKEN    @"AccessTokenKey"
#define KEY_EXPIRATION_DATE @"ExpirationDateKey"
#define KEY_USER_ID         @"UserIDKey"
#define KEY_REFRESH_TOKEN   @"refresh_token"

@implementation PTSinaWeiboClient {

}
- (id)init {
    self = [super init];
    if (self) {
        self.sinaWeibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:self];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *sinaWeiboInfo = [defaults objectForKey:SINA_WEIBO_AUTH_DATA];
        if ([sinaWeiboInfo objectForKey:KEY_ACCESS_TOKEN]
                && [sinaWeiboInfo objectForKey:KEY_EXPIRATION_DATE]
                && [sinaWeiboInfo objectForKey:KEY_USER_ID]) {

            _sinaWeibo.accessToken = [sinaWeiboInfo objectForKey:KEY_ACCESS_TOKEN];
            _sinaWeibo.expirationDate = [sinaWeiboInfo objectForKey:KEY_EXPIRATION_DATE];
            _sinaWeibo.userID = [sinaWeiboInfo objectForKey:KEY_USER_ID];
        }
    }

    return self;
}

- (void)login {
    [_sinaWeibo logIn];
}

- (void)logout {
    [_sinaWeibo logOut];
}

- (void)removeAuthData {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SINA_WEIBO_AUTH_DATA];
}

- (void)storeAuthData {
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
            _sinaWeibo.accessToken, KEY_ACCESS_TOKEN,
            _sinaWeibo.expirationDate, KEY_EXPIRATION_DATE,
            _sinaWeibo.userID, KEY_USER_ID,
            _sinaWeibo.refreshToken, KEY_REFRESH_TOKEN, nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:SINA_WEIBO_AUTH_DATA];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - SinaWeibo Delegate
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo {
    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@",
            sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate, sinaweibo.refreshToken);
    [self storeAuthData];
    if (_delegate && [_delegate respondsToSelector:@selector(sinaweiboDidLogIn:)]) {
        [_delegate sinaweiboDidLogIn:sinaweibo];
    }
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo {
    NSLog(@"sinaweiboDidLogOut");
    [self removeAuthData];
    if (_delegate && [_delegate respondsToSelector:@selector(sinaweiboDidLogOut:)]) {
        [_delegate sinaweiboDidLogOut:sinaweibo];
    }
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo {
    NSLog(@"sinaweiboLogInDidCancel");
    if (_delegate && [_delegate respondsToSelector:@selector(sinaweiboLogInDidCancel:)]) {
        [_delegate sinaweiboLogInDidCancel:sinaweibo];
    }
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error {
    NSLog(@"sinaweibo logInDidFailWithError %@", error);
    if (_delegate && [_delegate respondsToSelector:@selector(sinaweibo:logInDidFailWithError:)]) {
        [_delegate sinaweibo:sinaweibo logInDidFailWithError:error];
    }
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error {
    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
    [self removeAuthData];
    if (_delegate && [_delegate respondsToSelector:@selector(sinaweibo:accessTokenInvalidOrExpired:)]) {
        [_delegate sinaweibo:sinaweibo accessTokenInvalidOrExpired:error];
    }
}
@end