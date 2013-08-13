//
//  ImageDisplayController.m
//  pento
//
//  Created by xntech on 13-7-1.
//  Copyright (c) 2013年 xntech. All rights reserved.
//

#import "ImageDisplayController.h"
#import "UIViewAdditions.h"
#import "Helper.h"
#import "ImageDisplayView.h"
#import "AppDelegate.h"

#define SAVEBUTTON_TAG 9999

@interface ImageDisplayController ()
{
    NSArray  *_finalUrlList;
    NSArray  *_preImageList;
}
@property (nonatomic,strong)NSArray* finalUrlList;
@property (nonatomic,strong)NSArray* preImageList;
@end

@implementation ImageDisplayController
@synthesize finalUrlList = _finalUrlList,preImageList = _preImageList;

- (id)initWithImagesUrl:(NSArray *)urlList
{
    return  [self initWithImagesUrl:urlList preImage:nil];
}
- (id)initWithImagesUrl:(NSArray *)urlList preImage:(NSArray *)preImage
{
    self = [super init];
    if (self)
    {
        self.preImageList = preImage;
        self.finalUrlList = urlList;
    }
    return self;
}
- (void)reloadData:(NSArray *)urlList
{
    [self reloadData:urlList preImage:nil];
}

- (void)reloadData:(NSArray *)urlList preImage:(NSArray *)preImage
{
    [self clearView];
    self.finalUrlList = urlList;
    self.preImageList = preImage;
    
    [_contentScrollView scrollRectToVisible:CGRectZero animated:NO];
    [self setView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self clearView];

    _downloadImageIndexs = [[NSMutableArray alloc] initWithCapacity:self.finalUrlList.count];
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [_contentScrollView setPagingEnabled:YES];
    [_contentScrollView setBackgroundColor:[UIColor blackColor]];
    [_contentScrollView setDelegate:self];
    [_contentScrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_contentScrollView];
    if ([self.finalUrlList count] > 1) {
        _pageControll = [[UIPageControl alloc] initWithFrame:CGRectZero];
        [_pageControll setNumberOfPages:[self.finalUrlList count]];
        [_pageControll addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventTouchUpInside|UIControlEventValueChanged];
        [_pageControll setUserInteractionEnabled:NO];
        [self.view addSubview:_pageControll];
    }
    
    UIButton  *saveImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveImageButton addTarget:self action:@selector(savePhoto) forControlEvents:UIControlEventTouchUpInside];
    [saveImageButton setTag:SAVEBUTTON_TAG];
    [saveImageButton setBackgroundImage:[UIImage imageNamed:@"save_pic_btn"] forState:UIControlStateNormal];
    [saveImageButton setBackgroundImage:[UIImage imageNamed:@"save_pic_btns"] forState:UIControlStateSelected];
    [self.view addSubview:saveImageButton];
    [self setView];
    
    
    UILabel  *label = [[UILabel alloc] initWithFrame:CGRectMake(0, -3, 124, 44)];
    [saveImageButton addSubview:label];
    [label setText:@"      保存图片"];
    [label setTextAlignment:1];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    [label setShadowColor:[UIColor whiteColor]];
    [label setShadowOffset:CGSizeMake(0, 1)];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0  blue:0 alpha:1.0f]];
}
- (void)setView
{
    int preCount = [self.preImageList count];
    int finalCount = [self.finalUrlList count];
    for (int i = 0; i < finalCount; i ++)
    {
        UIImage *image = nil;
        if (i < preCount)
        {
            image = [self.preImageList objectAtIndex:i];
        }
        NSString  *urlString = [self.finalUrlList objectAtIndex:i];
        NSURL     *url = [NSURL URLWithString:urlString];
        
        
        __weak ImageDisplayController *controller = self;
        ImageDisplayView  *view = [[ImageDisplayView alloc] initWithFrame:CGRectZero];
        [view setUrl:url andPreImage:image];
        [_contentScrollView addSubview:view];
        [view setTag:i];
        [view setBackgroundColor:[UIColor clearColor]];
        [view setDissmissAction:^(void)
        {
            [controller back];
        }];
       
    }
    
    [self popViewRoatateChange];
}
- (void)clearView
{
    [_contentScrollView removeAllSubviews];
    [_downloadImageIndexs removeAllObjects];
}


- (void)setCurrentIndex:(int)currentIndex animated:(BOOL)anmated
{
    _currentIndex = currentIndex;
    float offset = _currentIndex * SCREEN_WIDTH;
    [_contentScrollView setContentOffset:CGPointMake(offset, 0) animated:anmated];
    
    [_pageControll setCurrentPage:_currentIndex];
}
- (void)setCurrentIndex:(int)currentIndex
{
    if (_currentIndex == currentIndex)
    {
        return;
    }
    [self setCurrentIndex:currentIndex animated:NO];
}

- (void)savePhoto
{
    UIImage *photo = [[self getImageDisplayView:_currentIndex] getImage];
    if (photo == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"请等待图片下载完成！"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"ok", nil];
        [alert show];
        return;
    }
    UIImageWriteToSavedPhotosAlbum(photo, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);


}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    NSString *tip = @"图片保存失败";
    if (error == nil)
    {
        tip = @"图片已保存到相册";
        
    }else if ([error code] == -3310){
        tip = @"请您在\"设置-隐私-照片\"中开启品读的权限";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:tip
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"ok", nil];
    [alert show];
}
- (ImageDisplayView *)getImageDisplayView:(int)index
{
    for(UIView  *view in _contentScrollView.subviews)
    {
        if ([view isKindOfClass:[ImageDisplayView class]]) {
            ImageDisplayView  *imageDisplayView = (ImageDisplayView *)view;
            if (imageDisplayView.tag == index) {
                return imageDisplayView;
            }
        }
    }
    return nil;
}
- (void)showToView:(UIView *)view
{
    [view addSubview:self.view];
    
    self.view.alpha = 0;
    __weak ImageDisplayController *wself = self;
    [UIView animateWithDuration:0.2 animations:^() {
        wself.view.alpha = 1.0;
    }];
}
- (void)back
{
//    [self dismissViewControllerAnimated:NO completion:nil];
    self.view.alpha = 1;
    __weak ImageDisplayController *wself = self;
    [UIView animateWithDuration:0.2 animations:^() {
        wself.view.alpha = 0.0;
    } completion:^(BOOL o) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];        
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int currentPage = floor((scrollView.contentOffset.x - SCREEN_WIDTH / 2) / SCREEN_WIDTH) + 1;
    if (_currentIndex == currentPage) {
        return;
    }
    _currentIndex = currentPage;
    [_pageControll setCurrentPage:_currentIndex];
}
- (void)popViewRoatateChange
{
    [self.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    int index = _currentIndex;
    int count = 0;
    [_contentScrollView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    for(UIView  *view in _contentScrollView.subviews)
    {
        if ([view isKindOfClass:[ImageDisplayView class]]) {
            ImageDisplayView  *imageDisplayView = (ImageDisplayView *)view;
            [imageDisplayView orientationChanged];
            count ++;
        }
    }
    
    [_contentScrollView setContentSize:CGSizeMake(SCREEN_WIDTH * count + 1, SCREEN_HEIGHT)];
    [_pageControll setFrame:CGRectMake(0, SCREEN_HEIGHT - 150, SCREEN_WIDTH, 100)];
    [[self.view viewWithTag:SAVEBUTTON_TAG] setFrame:CGRectMake(SCREEN_WIDTH - 150, SCREEN_HEIGHT - 80, 124, 44)];
    [self setCurrentIndex:index animated:NO];
}
- (void)pageChanged:(UIPageControl *)sender
{
    [self setCurrentIndex:sender.currentPage];
}
@end
