//
//  OrientationUtils.m
//  pento
//
//  Created by xntech on 13-7-4.
//  Copyright (c) 2013年 Pento. All rights reserved.
//

#import "OrientationUtils.h"
#import "SynthesizeSingleton.h"
#define SCREEN_WIDTH_S     768.0f
#define SCREEN_HEIGHT_S    1024.0f

@implementation OrientationUtils
@synthesize screenHeight,screenWidth;

SYNTHESIZE_SINGLETON_FOR_CLASS(OrientationUtils)
- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:INTERFACE_ORIENTATION_NOTIFICATION object:nil];
        _toInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        [self resetScreen];
    }
    return self;
}
- (float)screenHeight
{
    return _screenHeight;
}
- (float)screenWidth
{
    return _screenWidth;
}

- (void)orientationChanged:(NSNotification *)notification
{
    _toInterfaceOrientation = [notification.object integerValue];
    [self resetScreen];
}
- (void)resetScreen
{
    BOOL isPortrait = UIDeviceOrientationIsPortrait(_toInterfaceOrientation);
    if (isPortrait) {
        _screenHeight = SCREEN_HEIGHT_S - 20;
        _screenWidth = SCREEN_WIDTH_S;
    }else{
        _screenHeight = SCREEN_WIDTH_S - 20;
        _screenWidth = SCREEN_HEIGHT_S;
    }
}
- (BOOL)isVertical
{
    BOOL isPortrait = UIDeviceOrientationIsPortrait(_toInterfaceOrientation);
    return isPortrait;
}
@end
