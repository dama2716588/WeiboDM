//
//  SendWeiboViewController.m
//  WeiboDM
//
//  Created by ma yulong on 13-6-17.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

//1
//2
//3
//44444
//55555555

#import "SendWeiboViewController.h"
#import "UIImage+fixOrientation.h"
#import "UIImage+KIAdditions.h"
#import "MBProgressHUD.h"

#define BOOK_COVER_LR 20 //控制左右间隔
#define BOOK_COVER_UD 20 //控制上下间隔
#define COVER_WIDTH 70
#define COVER_HEIGHT 70
#define FIRST_COVER_MARGIN 10

@interface SendWeiboViewController ()

@end

@implementation SendWeiboViewController
{
    UITextView *_sendTextView;
    UIButton *_cameraBUtton;
    UIButton *_photoLibaryButton;
    UIButton *_leftButton;
    UIButton *_rightButton;
    UIView *_toolBarView;
    UIView *_showImagesView;
    NSMutableArray *_imagesArray;
    UIScrollView *_coversScrollView;
    CGFloat _lastWidth;
    CGFloat _coverHeight;
    PTSinaWeiboClient *_sinaWeiboClient;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _imagesArray = [[NSMutableArray alloc] init];
        _sinaWeiboClient = [[PTSinaWeiboClient alloc] init];
        _sinaWeiboClient.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"发布微博";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 7, 40, 30);
    [_leftButton setTitle:@"取消" forState:UIControlStateNormal];
    _leftButton.titleLabel.font = T12_FONT;
    _leftButton.layer.cornerRadius = 2;
    [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_leftButton setBackgroundColor:[UIColor grayColor]];
    [_leftButton addTarget:self action:@selector(cancelSend:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftButton];    
	
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(0, 7, 40, 30);
    [_rightButton setTitle:@"发送" forState:UIControlStateNormal];
    _rightButton.titleLabel.font = T12_FONT;
    _rightButton.layer.cornerRadius = 2;
    [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightButton setBackgroundColor:[UIColor grayColor]];
    [_rightButton addTarget:self action:@selector(doSend:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
        
    _sendTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    _toolBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    _toolBarView.backgroundColor = [UIColor colorWithRed:123/255.0f green:132/255.0f blue:143/255.0f alpha:1.0];
    _toolBarView.userInteractionEnabled = YES;
    UIButton *done = [UIButton buttonWithType:UIButtonTypeCustom];
    done.frame = CGRectMake(self.view.width - 50, 7, 40, 30);
    [done setTitle:@"完成" forState:UIControlStateNormal];
    done.titleLabel.font = TB_12_FONT;
    done.layer.cornerRadius = 2;
    [done setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [done setBackgroundColor:[UIColor whiteColor]];
    [done addTarget:_sendTextView action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchUpInside];    
    
    UIButton *camera = [UIButton buttonWithType:UIButtonTypeCustom];
    camera.frame = CGRectMake(10, 7, 30, 30);
    [camera setBackgroundImage:[UIImage imageNamed:@"camera_btn"] forState:UIControlStateNormal];
    [camera addTarget:self action:@selector(showCamera:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *photoLibary = [UIButton buttonWithType:UIButtonTypeCustom];
    photoLibary.frame = CGRectMake(60, 7, 30, 30);
    [photoLibary setBackgroundImage:[UIImage imageNamed:@"icon57"] forState:UIControlStateNormal];
    [photoLibary addTarget:self action:@selector(showPhotoLibary:) forControlEvents:UIControlEventTouchUpInside];
    
    [_toolBarView addSubview:photoLibary];
    [_toolBarView addSubview:camera];
    [_toolBarView addSubview:done];

    _sendTextView.font = T14_FONT;
    _sendTextView.keyboardType = UIKeyboardTypeDefault;
    _sendTextView.inputAccessoryView = _toolBarView;
    _sendTextView.inputView = nil;
    [_sendTextView becomeFirstResponder];
    
    _showImagesView = [[UIView alloc] initWithFrame:CGRectMake(0, _sendTextView.maxY + GAP_20, 320, 200)];
    _showImagesView.backgroundColor = [UIColor clearColor];
    _coversScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    [_showImagesView addSubview:_coversScrollView];
    
    [self.view addSubview:_sendTextView];
    [self.view addSubview:_showImagesView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelSend:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)doSend:(id)sender
{
    [_sendTextView resignFirstResponder];
    
    SinaWeibo *sinaWeibo = _sinaWeiboClient.sinaWeibo;
    NSString *accessToken = sinaWeibo.accessToken;    
    
    if (_imagesArray.count == 0) {
        [sinaWeibo requestWithURL:SINA_WEIBO_UPDATE_PATH
                           params:[@{@"access_token":accessToken,@"status":_sendTextView.text} mutableCopy]
                       httpMethod:@"POST"
                         delegate:self];
    }
    
    if (_imagesArray.count > 0) {
        UIImage *image = [_imagesArray objectAtIndex:0];
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        [sinaWeibo requestWithURL:SINA_WEIBO_UPLOAD_PATH
                           params:[@{@"access_token":accessToken,@"pic":data,@"status":_sendTextView.text} mutableCopy]
                       httpMethod:@"POST"
                         delegate:self];
    }

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];    
}

- (void)showCamera:(id)sender
{
    if (!self.imagePicker) {
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
    }
    
    self.imagePicker.sourceType =UIImagePickerControllerSourceTypeCamera;
    [self.navigationController presentModalViewController:self.imagePicker animated:YES];    
}

- (void)showPhotoLibary:(id)sender
{
    if (!self.imagePicker) {
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
    }
    
    self.imagePicker.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
    [self.navigationController presentModalViewController:self.imagePicker animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImage *fixedImage = [image fixOrientation]; // fix image from camera
    
    CGFloat imageW = fixedImage.size.width;
    CGFloat imageH = fixedImage.size.height;
    NSLog(@"image --- %f ---- %f",imageW,imageH);
    
    if(fixedImage){
        picker.navigationBarHidden = NO;
        ImageFilterViewController *filter = [[ImageFilterViewController alloc] initWithImage:fixedImage];
        filter.delegate = self;
        [picker pushViewController:filter animated:YES];
    }        
}

#pragma mark - ImageFilterViewControllerDelegate

- (void)filterControllerCanceled:(ImageFilterViewController *)controller{
    
}

- (void)filterController:(ImageFilterViewController *)controller finishWithImageInfo:(NSDictionary *)info{
    UIImage *filteredImage = [info objectForKey:kFilteredImage];
    [_imagesArray removeAllObjects];
    [_imagesArray addObject:filteredImage];
    [self.imagePicker dismissModalViewControllerAnimated:YES];
    [self showImages];    
}

- (void)showImages
{
    NSArray *array = [NSArray arrayWithArray:_imagesArray];
    if(array.count == 0) return;
    
    _lastWidth = FIRST_COVER_MARGIN;
    _coverHeight = 20;
    
    for (int j=0; j<array.count; j++)
    {
        if (_lastWidth + COVER_WIDTH > 300)
        {
            _lastWidth = FIRST_COVER_MARGIN;
            _coverHeight += BOOK_COVER_UD + COVER_WIDTH ;
        }
        
        UIImageView *bookCover = [[UIImageView alloc] initWithImage:[array objectAtIndex:j]];
        bookCover.contentMode = UIViewContentModeScaleAspectFill;
        bookCover.clipsToBounds = YES;
        bookCover.frame = CGRectMake(_lastWidth, _coverHeight, COVER_WIDTH, COVER_HEIGHT);
        bookCover.backgroundColor = [UIColor grayColor];
        bookCover.userInteractionEnabled = YES;
        bookCover.tag = j;
        [_coversScrollView addSubview:bookCover];
        _lastWidth += COVER_WIDTH + BOOK_COVER_LR;        
    }
}

- (void)showPrompt:(NSString *)prompt delay:(NSTimeInterval)delay
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (prompt.length > 14) {
        hud.labelFont = [UIFont systemFontOfSize:13];
    }
    hud.mode = MBProgressHUDModeText;
    hud.labelText = prompt;
    hud.yOffset = (self.navigationController.view ? 0 : -32);
    [hud hide:YES afterDelay:delay];
}

#pragma mark - SinaWeiboRequestDelegate

-(void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"send_weibo_error : %@",error);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self showPrompt:@"发布失败" delay:0.8];
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    NSLog(@"send_weibo_result : %@",result);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self.imagePicker dismissModalViewControllerAnimated:YES];    
    [self showPrompt:@"发布成功" delay:0.8];

}

@end
