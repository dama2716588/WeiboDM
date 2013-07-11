//
//  SinaWeiboCell.m
//  WeiboDM
//
//  Created by ma yulong on 13-5-26.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import "SinaWeiboCell.h"
#import "MainViewController.h"
#import "GHImagePreView.h"
#import "Helper.h"

#define sinaWeiboMaxTextHeight 360
#define imageViewHeight 200

@implementation SinaWeiboCell
{
    OHAttributedLabel *_textLabel;
    UIImageView *_imageView;
    UIView *_whiteBGView;
    UILabel *_pinNumberLabel;
    UILabel *_zfNumberLabel;
    UILabel *_pinTimeLabel;
    SinaWeiboModel *_model;
    UIImageView *_pinCountImageView;
    UIImageView *_zfCountImageVIew;
    UIImageView *_verticalLineImageView;
    UIImageView *_horizontalLineImageView;
    UIImageView *_userIconBGImageView;
    UIImageView *_userIconImageView;
    UILabel *_userNameLabel;
    UIButton *_pinButton;
    UILabel *_repostTitle;
}

+ (CGSize)getTextLabelSize:(SinaWeiboModel *)model {
    
    SinaWeiboModel *originalWeibo = model.sinaRepost ? model.sinaRepost : model ;
    
//    NSString *originText = originalWeibo.text;
//    NSString *subText;
//    if(originText.length > 20) subText = [originText substringToIndex:20];
//    else subText = originText;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:originalWeibo.text];
    CGSize size = CGSizeMake([MainViewController cellWidth] - GAP_15 * 2, sinaWeiboMaxTextHeight);
    [text setFont:T14_FONT];
    return [text sizeConstrainedToSize:size];
}

+ (CGSize)getTitleLabelSize:(SinaWeiboModel *)model {
    
    if (model.sinaRepost) {
        CGSize size = CGSizeMake([MainViewController cellWidth] - GAP_15 * 2, 100);
        return [model.text sizeWithFont:T16_FONT
                      constrainedToSize:size
                          lineBreakMode:NSLineBreakByClipping];
    }
    
    return CGSizeZero;
    
}

+ (CGSize)getContentLabelSize:(SinaWeiboModel *)model {
    float contentMaxHeight = 200;
    if (model.image_width == 0 || model.image_height == 0) {
        contentMaxHeight = 400;
    }
    CGSize size = CGSizeMake([MainViewController cellWidth] - GAP_15 * 4, contentMaxHeight);
    return [model.short_content sizeWithFont:T14_FONT constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
}

+ (float)calculateCardHeight:(SinaWeiboModel *)model {
    
    CGSize sizeTitle = [self getTitleLabelSize:model];
    CGSize sizeText = [self getTextLabelSize:model];
    CGSize sizeContent = [self getContentLabelSize:model];
    CGSize s = CGSizeMake([MainViewController cellWidth], 50);
    CGSize sizePinCountTime = [[NSString stringWithFormat:@"%d", model.repin_count] sizeWithFont:T12_FONT constrainedToSize:s lineBreakMode:NSLineBreakByTruncatingTail];
    CGFloat h =  imageViewHeight + sizeTitle.height + sizeText.height + sizeContent.height + sizePinCountTime.height + GAP_15 * 2 + GAP_10 + 74 + 2 * (sizeContent.height == 0 ? 0 : GAP_15);
    if (model.bmiddle_pic) {
        return h - GAP_15;
    } else {
        return h - GAP_15 - imageViewHeight;
    }
}

- (NSString *)getFormatString:(NSString *)aString
{
    NSString *myDateString = aString;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en"]];
    [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss z yyyy"];
    NSDate *theDate  = [dateFormatter dateFromString:myDateString];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *newDateString = [dateFormatter stringFromDate:theDate];
    
    return newDateString;
}

- (void)updateCellWithData:(SinaWeiboModel *)model
{
    
    _model = model;
    SinaWeiboModel *originalWeibo = _model.sinaRepost ? _model.sinaRepost : _model ;
    
    _repostTitle.text = _model.text;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:originalWeibo.text];
    [text setFont:T14_FONT];    
    _textLabel.attributedText = text;
    
    _pinNumberLabel.text = [NSString stringWithFormat:@"%d",_model.reposts_count];
    [_pinNumberLabel sizeToFit];
    
    _zfNumberLabel.text = [NSString stringWithFormat:@"%d",_model.comments_count];
    [_zfNumberLabel sizeToFit];
    
    _pinTimeLabel.text = [Helper getPinTimeString:[self getFormatString:_model.created_at]];
    [_pinTimeLabel sizeToFit];
    
    NSURL *url = [NSURL URLWithString:originalWeibo.bmiddle_pic];    
    __weak UIImageView *_imageViewRef = _imageView;
    [_imageView setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image) {
            [_imageViewRef setAlpha:0.0f];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.8f];
            [_imageViewRef setAlpha:1.0f];
            [UIView commitAnimations];
        }
    }];
    
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
    [_imageView addGestureRecognizer:tapImage];
        
    NSString *titleStr = _model.sinaUser.screen_name;
    NSString *subTitle;
    if(titleStr.length > 8){
        subTitle = [titleStr substringToIndex:8];}
    else {
        subTitle = titleStr;
    }
    
    _userNameLabel.text = subTitle;
    [_userNameLabel sizeToFit];
    
    NSURL *userIconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",_model.sinaUser.profile_image_url]];
    UIImage *userImage = [UIImage imageNamed:@"default_avatar_icon.png"];    
    __weak UIImageView *userImageView = _userIconImageView;
    [_userIconImageView setImageWithURL:userIconUrl placeholderImage:userImage completed:^(UIImage *fImage,NSError *error,SDImageCacheType type)
     {
         if (fImage != nil)
         {
             [userImageView setAlpha:0.0f];
             [UIView beginAnimations:nil context:nil];
             [UIView setAnimationDuration:0.8f];
             [userImageView setAlpha:1.0f];
             [UIView commitAnimations];
         }
     }];
        
    [self setNeedsDisplay];    
}

- (void)clickImage:(UITapGestureRecognizer *)tap
{
    UIImageView *imageView = (UIImageView *)[tap view];
    GHImagePreView *preview = [[GHImagePreView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    preview.imageUrl = _model.original_pic;
    [preview showFromView:imageView];
}

- (void)clickRepostImage:(UITapGestureRecognizer *)tap
{
    UIImageView *imageView = (UIImageView *)[tap view];
    GHImagePreView *preview = [[GHImagePreView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    preview.imageUrl = _model.sinaRepost.original_pic;
    [preview showFromView:imageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    SinaWeiboModel *originalPin = _model;
    
    CGSize sizeText = [[self class] getTextLabelSize:_model];
    CGSize sizeContent = [[self class] getContentLabelSize:originalPin];
    CGSize sizeTitle = [[self class] getTitleLabelSize:_model];
    
    _repostTitle.frame = CGRectMake(0, 0, sizeTitle.width, sizeTitle.height);
    _textLabel.frame = CGRectMake(0, _repostTitle.height, sizeText.width, sizeText.height);
    
    if (_model.bmiddle_pic) {
        _imageView.frame = CGRectMake(0, 0, self.contentView.width - GAP_15 * 2, imageViewHeight);
        _whiteBGView.frame = CGRectMake(0, 0, _imageView.width + 2, _imageView.height +  2 * (sizeContent.height == 0 ? 0 : GAP_15) + 2);
        _textLabel.textColor = [UIColor darkGrayColor];
    } else {
        _imageView.frame = CGRectZero;
        _whiteBGView.frame = CGRectZero;
        _textLabel.textColor = [UIColor grayColor];
    }
    
    [_pinCountImageView changePosition:CGPointMake(GAP_15+ 0.5, GAP_10 + 0.5)];
    _pinNumberLabel.center = CGPointMake(_pinCountImageView.minX + _pinCountImageView.width + _pinNumberLabel.width / 2, _pinCountImageView.centerY);
    [_zfCountImageVIew changePosition:CGPointMake(GAP_15+ 0.5 + _pinCountImageView.width + _pinNumberLabel.width + 10, GAP_10 + 0.5 )];
    _zfNumberLabel.center = CGPointMake(_zfCountImageVIew.minX + _zfCountImageVIew.width  + _zfNumberLabel.width / 2, _zfCountImageVIew.centerY);
    _pinTimeLabel.center = CGPointMake(self.contentView.width - GAP_15 - _pinTimeLabel.width / 2, _pinNumberLabel.centerY);    
    [_repostTitle changePosition:CGPointMake(GAP_15, GAP_15 + _pinCountImageView.height)];
    
    CGFloat imgH = _repostTitle.height == 0 ? _pinCountImageView.height : _repostTitle.height;
    [_imageView changePosition:CGPointMake(GAP_15, GAP_20 + imgH)];
    CGFloat titH = _model.sinaRepost.text ? GAP_25 : GAP_5;
    CGFloat showImage = _model.bmiddle_pic ? GAP_5 : 0;
    [_textLabel changePosition:CGPointMake(GAP_15, _imageView.maxY + titH + showImage)];
    [_whiteBGView changePosition:CGPointMake(GAP_15- 1, _imageView.minY - 1)];
    
    [_userIconImageView changePosition:CGPointMake(GAP_15,  _textLabel.maxY + GAP_10)];
    _userIconBGImageView.center = _userIconImageView.center;
    [_userNameLabel changePosition:CGPointMake(GAP_15+ GAP_5 + _userIconImageView.width, _textLabel.maxY + GAP_20)];
    [_pinButton changePosition:CGPointMake(self.contentView.width - GAP_15 - _pinButton.width, _textLabel.maxY + GAP_20)];
    
    _verticalLineImageView.frame = CGRectMake(0, 0, _verticalLineImageView.width, self.contentView.height + 2);
    _horizontalLineImageView.frame = CGRectMake(0, 0, self.contentView.width, _horizontalLineImageView.height);
    _verticalLineImageView.center = CGPointMake(self.contentView.width, self.contentView.height / 2);
    _horizontalLineImageView.center = CGPointMake(self.contentView.width / 2, self.contentView.height);
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _imageView = [[UIImageView alloc] init];
        [_imageView setClipsToBounds:YES];
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        _textLabel = [[OHAttributedLabel alloc] init];
        _textLabel.delegate = self;        
        _textLabel.numberOfLines = 0;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.lineBreakMode = NSLineBreakByClipping;
        
        _repostTitle = [[UILabel alloc] init];
        _repostTitle.numberOfLines = 0;
        _repostTitle.textColor = P6_COLOR;
        _repostTitle.font = T16_FONT;
        _repostTitle.backgroundColor = [UIColor clearColor];
        _repostTitle.textAlignment = NSTextAlignmentLeft;
        _repostTitle.lineBreakMode = NSLineBreakByClipping;
        
        _pinNumberLabel = [[UILabel alloc] init];
        _pinNumberLabel.backgroundColor = [UIColor clearColor];
        _pinNumberLabel.font = T12_FONT;
        _pinNumberLabel.textColor = P4_COLOR;
        
        _zfNumberLabel = [[UILabel alloc] init];
        _zfNumberLabel.backgroundColor = [UIColor clearColor];
        _zfNumberLabel.font = T12_FONT;
        _zfNumberLabel.textColor = P4_COLOR;
        
        _pinTimeLabel = [[UILabel alloc] init];
        _pinTimeLabel.backgroundColor = [UIColor clearColor];
        _pinTimeLabel.textColor = P4_COLOR;
        _pinTimeLabel.font = [UIFont systemFontOfSize:10.0f];
        
        _whiteBGView = [[UIView alloc] init];
        _whiteBGView.backgroundColor = P1_COLOR;
        
        _pinCountImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhuanfa_small_icon.png"]];
        _zfCountImageVIew = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pinglun_small_icon.png"]];
        _verticalLineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vertical_line.png"]];
        _horizontalLineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"horizontal_line.png"]];
        _userIconBGImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar_icon_bg.png"]];
        
        _userIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _userIconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openWithUrl:)];
        [_userIconImageView addGestureRecognizer:tap];
        
        CALayer *layer = [_userIconImageView layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:_userIconImageView.frame.size.width / 2];
        
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.backgroundColor = [UIColor clearColor];
        _userNameLabel.textColor = P5_COLOR;
        _userNameLabel.font = T14_FONT;
        
        _pinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pinButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _pinButton.frame = CGRectMake(0, 0, 32, 32);
        [_pinButton setImage:[UIImage imageNamed:@"btn_p_normal.png"] forState:UIControlStateNormal];
        [_pinButton setImage:[UIImage imageNamed:@"btn_p_pressed.png"] forState:UIControlStateHighlighted];
        
        
        [self.contentView addSubview:_repostTitle];
        [self.contentView addSubview:_whiteBGView];
        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:_textLabel];
        [self.contentView addSubview:_pinNumberLabel];
        [self.contentView addSubview:_zfNumberLabel];
        [self.contentView addSubview:_pinTimeLabel];
        [self.contentView addSubview:_pinCountImageView];
        [self.contentView addSubview:_zfCountImageVIew];
        [self.contentView addSubview:_verticalLineImageView];
        [self.contentView addSubview:_horizontalLineImageView];
        [self.contentView addSubview:_userIconBGImageView];
        [self.contentView addSubview:_userIconImageView];
        [self.contentView addSubview:_userNameLabel];
        [self.contentView addSubview:_pinButton];
    }
    return self;
}

- (void)buttonClicked:(id)sender
{
    //
}

- (void)openWithUrl:(UITapGestureRecognizer *)tap
{
    SinaWeiboModel *origin = _model;
    if (_delegate && [_delegate respondsToSelector:@selector(gotoPersonWith:)]) {
        [_delegate gotoPersonWith:origin.sinaUser];
    }
    
//    if ([_delegate respondsToSelector:@selector(openWeiboWithUrl:)]) {
//        [_delegate openWeiboWithUrl:[NSString stringWithFormat:@"http://weibo.com/%@",origin.sinaUser.domain]];
//    }
}

-(BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel shouldFollowLink:(NSTextCheckingResult *)linkInfo
{
    if ([_delegate respondsToSelector:@selector(openWeiboWithUrl:)]) {
        [_delegate openWeiboWithUrl:[linkInfo.URL absoluteString]];
    }
    return NO;
}

@end
