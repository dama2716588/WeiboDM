//
//  GHImagePreVIew.h
//  notebook
//
//  Created by 诗彬 刘 on 12-5-17.
//  Copyright (c) 2012年 ifuninfo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GHImagePreView : UIView{

}
@property(nonatomic,retain)UIImage *thumbImage;
@property(nonatomic,retain)UIImage *image;
@property(nonatomic,copy)NSString *imageUrl;
- (void)showFromView:(UIView *)aView;
@end
