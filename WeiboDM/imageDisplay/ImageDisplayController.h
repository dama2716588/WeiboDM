//
//  ImageDisplayController.h
//  pento
//
//  Created by xntech on 13-7-1.
//  Copyright (c) 2013年 xntech. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ImageDisplayController : UIViewController<UIScrollViewDelegate>
{
    UIScrollView   *_contentScrollView;
    UIPageControl  *_pageControll;
    NSMutableArray *_downloadImageIndexs;
}
@property (nonatomic,assign)int currentIndex;
- (id)initWithImagesUrl:(NSArray *)urlList;
- (id)initWithImagesUrl:(NSArray *)urlList preImage:(NSArray *)preImage;

- (void)reloadData:(NSArray *)urlList;
- (void)reloadData:(NSArray *)urlList preImage:(NSArray *)preImage;
- (void)showToView:(UIView *)view;
@end
