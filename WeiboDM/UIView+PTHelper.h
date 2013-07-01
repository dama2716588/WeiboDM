//
// Created by eric on 13-3-27.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (PTHelper)
@property(readwrite, copy) id userData;
-(void)changePosition:(CGPoint)point;
-(float)minX;
-(float)minY;
-(float)maxX;
-(float)maxY;
-(float)centerX;
-(float)centerY;
-(float)width;
-(float)height;
@end