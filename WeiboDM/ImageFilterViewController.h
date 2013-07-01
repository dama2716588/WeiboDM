//
//  ImageFilterViewController.h
//  notebook
//
//  Created by Stephen Liu on 12-8-27.
//  Copyright (c) 2012年 ifuninfo. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const NSString* kFilteredImage;
@class ImageFilterViewController;
@protocol ImageFilterViewControllerDelegate <NSObject>
- (void)filterControllerCanceled:(ImageFilterViewController *)controller;
- (void)filterController:(ImageFilterViewController *)controller finishWithImageInfo:(NSDictionary *)info;
@end

@interface ImageFilterViewController : UIViewController{
    UIImage *originImage;
    UIImage *filteredImage;
}
@property(nonatomic,assign)id<ImageFilterViewControllerDelegate> delegate;
@property(nonatomic,retain)UIImage *originImage;
@property(nonatomic,readonly)UIImage *filteredImage;
- (id)initWithImage:(UIImage *)image;
@end
