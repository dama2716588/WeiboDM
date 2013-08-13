//
//  OrientationUtils.h
//  pento
//
//  Created by xntech on 13-7-4.
//  Copyright (c) 2013年 Pento. All rights reserved.
//

#import <Foundation/Foundation.h>

#define  Orientation  [OrientationUtils sharedOrientationUtils]
@interface OrientationUtils : NSObject
{
    UIInterfaceOrientation _toInterfaceOrientation;
    float                  _screenHeight;
    float                  _screenWidth;
}
@property (nonatomic,assign,readonly)UIInterfaceOrientation toInterfaceOrientation;
@property (nonatomic,assign,readonly)float screenHeight;
@property (nonatomic,assign,readonly)float screenWidth;
+(OrientationUtils *)sharedOrientationUtils;
- (BOOL)isVertical;
@end
