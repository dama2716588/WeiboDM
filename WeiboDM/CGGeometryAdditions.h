//
//  CGGeometryAdditions.h
//
//  Created by guo hua on 11-9-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
struct CGOffset {
    CGFloat x;
    CGFloat y;
};
typedef struct CGOffset CGOffset;

CGPoint  CGRectGetCenter(CGRect rect);
BOOL     UIViewContainsPoint(UIView *view,CGPoint point);
CGPoint  CGPointGetCenter(CGPoint p1,CGPoint p2);
CGPoint  CGPointConvertToRect(CGPoint point,CGRect rect);
CGRect   CGRectMakeWithCenterAndSize(CGPoint center,CGSize size);
CGOffset CGOffsetMake(CGFloat x,CGFloat y);
CGOffset CGOffsetBetween(CGPoint p1,CGPoint p2);
CGPoint  CGPointWithOffset(CGPoint point,CGOffset offset);
CGSize   CGSizeScaleDistance(CGSize size,CGFloat distance);
CGSize   CGSizeApplyScale(CGSize size, CGFloat scale);

CGPoint  CGPointBetweenPoints(CGPoint p1,CGPoint p2,CGFloat percent);

CGFloat  CGPointGetDistance(CGPoint p1,CGPoint p2);
CGFloat  CGPointGetAngle(CGPoint p,CGPoint center);

CGPathRef CGPathCreatRoundedWithRadius(CGRect rect,CGFloat radius);