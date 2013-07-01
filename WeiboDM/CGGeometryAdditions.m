//
//  CGGeometryAdditions.m
//
//  Created by guo hua on 11-9-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CGGeometryAdditions.h"
CGFloat CGPointGetDistance(CGPoint p1,CGPoint p2){
    return sqrtf((p1.x-p2.x)*(p1.x-p2.x)+(p1.y-p2.y)*(p1.y-p2.y));
}

CGFloat CGPointGetAngle(CGPoint p,CGPoint center){
    CGFloat angle = -1;
    CGFloat r = CGPointGetDistance(p, center);
    if (r<=0) {
        return 0;
    }
    CGFloat x = p.x - center.x;
    CGFloat y = p.y - center.y;
    CGFloat cos = x/r;

    if(y < 0){
        angle = acosf(cos);
    }else if(y > 0){
        angle = 2*M_PI - acosf(cos);
    }else if(y == 0){
        return x>0?0:M_PI;
    }
    return angle;
}

CGPoint CGRectGetCenter(CGRect rect){
    return CGPointMake(rect.origin.x+(rect.size.width/2), rect.origin.y+(rect.size.height/2));
}

BOOL UIViewContainsPoint(UIView *view,CGPoint point){
    CGPoint point1 = [view convertPoint:point fromView:view.superview];
    return [view pointInside:point1 withEvent:nil];
    return CGRectContainsPoint(view.frame, point);
}

CGPoint  CGPointGetCenter(CGPoint p1,CGPoint p2){
    return CGPointMake((p1.x+p2.x)/2, (p1.y+p2.y)/2);
}

CGPoint  CGPointConvertToRect(CGPoint point,CGRect rect){
    CGPoint origin = rect.origin;
    return CGPointMake(point.x - origin.x, point.y - origin.y);
}

CGRect  CGRectMakeWithCenterAndSize(CGPoint center,CGSize size){
    CGRect r = CGRectZero;
    r.size = size;
    r.origin = CGPointMake(center.x-size.width/2, center.y - size.height/2);
    return r;
}

CGOffset CGOffsetMake(CGFloat x,CGFloat y){
    CGOffset offset;
    offset.x = x;
    offset.y = y;
    return offset;
}

CGOffset CGOffsetBetween(CGPoint p1,CGPoint p2){
    return CGOffsetMake(p2.x - p1.x, p2.y - p1.y);
}

CGPoint CGPointWithOffset(CGPoint point,CGOffset offset){
    return CGPointMake(point.x+offset.x, point.y+offset.y);
}

CGSize   CGSizeApplyScale(CGSize size, CGFloat scale){
    return CGSizeMake(size.width*scale, size.height*scale);
}

CGSize  CGSizeScaleDistance(CGSize size, CGFloat distance){
    CGFloat olddistance = sqrtf(size.width*size.width+size.height*size.height);
    if (olddistance<=0) {
        return CGSizeZero;
    }
    CGFloat scale = distance/olddistance + 1;
    return CGSizeMake(size.width*scale, size.height*scale);
}

CGPoint CGPointBetweenPoints(CGPoint p1,CGPoint p2,CGFloat percent){
    return CGPointMake(p1.x + percent*(p2.x-p1.x), p1.y + percent*(p2.y-p1.y));
}


CGPathRef CGPathCreatRoundedWithRadius(CGRect rect,CGFloat radius){
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect));
    CGPathAddArc(path, NULL, CGRectGetMaxX(rect) - radius, CGRectGetMinY(rect) + radius, radius, 3 * M_PI_2, 0, 0);
    CGPathAddArc(path, NULL, CGRectGetMaxX(rect) - radius, CGRectGetMaxY(rect) - radius, radius, 0, M_PI_2, 0);
    CGPathAddArc(path, NULL, CGRectGetMinX(rect) + radius, CGRectGetMaxY(rect) - radius, radius, M_PI_2, M_PI, 0);
    CGPathAddArc(path, NULL, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect) + radius, radius, M_PI, 3*M_PI_2, 0);
    CGPathCloseSubpath(path);
    return path;
}