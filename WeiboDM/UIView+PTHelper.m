//
// Created by eric on 13-3-27.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <objc/runtime.h>

@implementation UIView (PTHelper)
static char userDataKey;

- (NSString *)userData {
    return objc_getAssociatedObject(self, &userDataKey);
}

- (void)setUserData:(id)userData {
    objc_setAssociatedObject(self, &userDataKey, userData, OBJC_ASSOCIATION_COPY);
}

- (void)changePosition:(CGPoint)point {
    self.frame = CGRectMake(point.x, point.y, self.width, self.height);
}

- (float)minX {
    return self.frame.origin.x;
}

- (float)minY {
    return self.frame.origin.y;
}

- (float)maxX {
    return self.frame.origin.x + self.width;
}

- (float)maxY {
    return self.frame.origin.y + self.height;
}

- (float)centerX {
    return self.center.x;
}

- (float)centerY {
    return self.center.y;
}

- (float)width {
    return self.frame.size.width;
}

- (float)height {
    return self.frame.size.height;
}
@end