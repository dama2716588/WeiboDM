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

#define sinaWeiboMaxTextHeight 80
#define sinaWeiboMaxTitleHeight 100
#define imageViewHeight 200

#define BOOK_COVER_LR 1 //左右间隔
#define BOOK_COVER_UD 1 //上下间隔
#define COVER_WIDTH 30
#define COVER_HEIGHT 30
#define FIRST_COVER_MARGIN 15

@implementation SinaWeiboCell
{
    OHAttributedLabel *_textLabel;
    UIImageView *_imageView;
    UIImageView *_whiteBGView;
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
    OHAttributedLabel *_repostTitle;
    UIImageView *_userIconCover;
    
    //多图
    CGFloat _lastWidth;
    CGFloat _coverHeight;
    UIView *_multiImagesView;
    NSMutableArray *_multiImagesArray;
    NSMutableArray *_urls;
}

OHParagraphStyle* textParagraphStyle() {
    OHParagraphStyle *paragraphStyle = [[OHParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    return paragraphStyle;
}

OHParagraphStyle* contentParagraphStyle() {
    OHParagraphStyle *paragraphStyle = [[OHParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    return paragraphStyle;
}

+ (CGSize)getTextLabelSize:(SinaWeiboModel *)model {
    
    SinaWeiboModel *originalWeibo = model.sinaRepost ? model.sinaRepost : model ;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:originalWeibo.text];
    
    CGSize size = CGSizeMake([MainViewController cellWidth] - GAP_15 * 2 - GAP_10, sinaWeiboMaxTextHeight);
    [text setFont:T14_FONT];
    [text setParagraphStyle:contentParagraphStyle()];
    return [text sizeConstrainedToSize:size];
}

+ (CGSize)getTitleLabelSize:(SinaWeiboModel *)model {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:model.text];
    
    if (model.sinaRepost) {
        CGSize size = CGSizeMake([MainViewController cellWidth] - GAP_15 * 2, sinaWeiboMaxTitleHeight);
        [text setFont:T16_FONT];
        [text setParagraphStyle:textParagraphStyle()];
        return [text sizeConstrainedToSize:size];
    }
    
    return CGSizeZero;
    
}

+ (float)calculateCardHeight:(SinaWeiboModel *)model {
    
    CGSize sizeTitle = [self getTitleLabelSize:model];
    CGSize sizeText = [self getTextLabelSize:model];
    CGSize s = CGSizeMake([MainViewController cellWidth], 50);
    CGSize sizePinCountTime = [[NSString stringWithFormat:@"%d", model.repin_count] sizeWithFont:T12_FONT constrainedToSize:s lineBreakMode:NSLineBreakByTruncatingTail];
    CGFloat h =  imageViewHeight + sizeTitle.height + sizeText.height + sizePinCountTime.height + GAP_15 * 2 + GAP_10 + 74;
    
    if (model.pic_urls.count > 1) {
        return h - imageViewHeight + [[self class] getMultiImageHeight:model] - GAP_5;
    }
    
    if ( model.sinaRepost.pic_urls.count > 1) {
        return h - imageViewHeight + [[self class] getMultiImageHeight:model] + GAP_5;
    }
    
    if (model.bmiddle_pic) {
        return h - GAP_5;
    }
    
    else if (model.sinaRepost.bmiddle_pic){
        return h + GAP_15;
    }
    
    else {
        
        if (model.sinaRepost.text.length > 0) {
            return h - imageViewHeight + GAP_15;
        }
        
        return h - imageViewHeight + GAP_5;
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

- (void)updateCellWithData:(SinaWeiboModel *)model {
    _model = model;
    SinaWeiboModel *originalWeibo = _model.sinaRepost ? _model.sinaRepost : _model;
    
    NSMutableAttributedString *textR = [[NSMutableAttributedString alloc] initWithString:_model.text];
    [textR setFont:T16_FONT];
    [textR setParagraphStyle:textParagraphStyle()];
    _repostTitle.attributedText = textR;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:originalWeibo.text];
    [text setFont:T14_FONT];
    [text setParagraphStyle:contentParagraphStyle()];
    _textLabel.attributedText = text;
    
    _pinNumberLabel.text = [NSString stringWithFormat:@"%d",_model.reposts_count];
    [_pinNumberLabel sizeToFit];
    
    _zfNumberLabel.text = [NSString stringWithFormat:@"%d",_model.comments_count];
    [_zfNumberLabel sizeToFit];
    
    _pinTimeLabel.text = [Helper getPinTimeString:[self getFormatString:_model.created_at]];
    [_pinTimeLabel sizeToFit];
    [_imageView setImageWithURL:[NSURL URLWithString:originalWeibo.bmiddle_pic] placeholderImage:nil];
    
    NSString *titleStr = _model.sinaUser.screen_name;
    NSString *subTitle;
    if(titleStr.length > 16){
        subTitle = [titleStr substringToIndex:16];}
    else {
        subTitle = titleStr;
    }
    
    _userNameLabel.text = subTitle;
    [_userNameLabel sizeToFit];
    [_userIconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_model.sinaUser.profile_image_url]] placeholderImage:[UIImage imageNamed:@"default_avatar_icon.png"]];
    
    //add multi images
    SinaWeiboModel *originModel = model.sinaRepost ? model.sinaRepost : model;
    if (originModel.pic_urls.count > 1) {
        [self createMultiImagesView:originModel];
    } else {
        [_multiImagesView removeFromSuperview];
    }
    
    [self setNeedsLayout];
}

- (void)createMultiImagesView:(SinaWeiboModel *)model
{
    [_multiImagesView removeAllSubviews];
    [_multiImagesView removeFromSuperview];
    [_urls removeAllObjects];
    
    NSArray *urlsArray = model.pic_urls;
    CGFloat h = [[self class] getMultiImageHeight:model];
    
    _multiImagesView.frame = CGRectMake(0, 0, 100, h);
    
    _lastWidth = FIRST_COVER_MARGIN;
    _coverHeight = 0;
    
    for (int j=0; j<urlsArray.count; j++)
    {
        if (_lastWidth + COVER_WIDTH > 110)
        {
            _lastWidth = FIRST_COVER_MARGIN;
            _coverHeight += BOOK_COVER_UD + COVER_WIDTH ;
        }
        
        NSString *thumbnailUrl = [[urlsArray objectAtIndex:j] objectForKey:@"thumbnail_pic"];
        NSString *largeUrl = [thumbnailUrl stringByReplacingOccurrencesOfString:@"/thumbnail" withString:@"/large"];
        [_urls addObject:largeUrl];
        
        UIImageView *bookCover = [[UIImageView alloc] init];
        [bookCover setImageWithURL:[NSURL URLWithString:thumbnailUrl]];
        bookCover.contentMode = UIViewContentModeScaleAspectFill;
        bookCover.clipsToBounds = YES;
        bookCover.frame = CGRectMake(_lastWidth, _coverHeight, COVER_WIDTH, COVER_HEIGHT);
        bookCover.backgroundColor = [UIColor whiteColor];
        bookCover.userInteractionEnabled = YES;
        bookCover.tag = j;
        [_multiImagesView addSubview:bookCover];
        _lastWidth += COVER_WIDTH + BOOK_COVER_LR;
        
        [_multiImagesArray addObject:bookCover];
    }
    [_whiteBGView addSubview:_multiImagesView];
}

+ (float)getMultiImageHeight:(SinaWeiboModel *)model
{
    SinaWeiboModel *originModel = model.sinaRepost ? model.sinaRepost : model;
    
    if (originModel.pic_urls.count <= 1) {
        return 0;
    }
    
    if (originModel.pic_urls.count <= 3) {
        return COVER_HEIGHT;
    }
    
    if (originModel.pic_urls.count <= 6) {
        return COVER_HEIGHT*2 + BOOK_COVER_UD;
    }
    
    return COVER_HEIGHT*3 + BOOK_COVER_UD*2;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize sizeText = [[self class] getTextLabelSize:_model];
    CGSize sizeTitle = [[self class] getTitleLabelSize:_model];
    
    _repostTitle.frame = CGRectMake(0, 0, sizeTitle.width, sizeTitle.height);
    [_repostTitle changePosition:CGPointMake(GAP_15, GAP_10 + 0)];
    _textLabel.frame = CGRectMake(GAP_5, _repostTitle.height + GAP_10, sizeText.width, sizeText.height + GAP_10);
    
    if (_model.sinaRepost.text.length > 0) {
        self.repostBGImage =[[UIImage imageNamed:@"zhuanfa_weibo_bg.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:50];
        _whiteBGView.image = self.repostBGImage;
        _whiteBGView.backgroundColor = [UIColor clearColor];
    } else {
        self.repostBGImage = nil;
        _whiteBGView.image = nil;
        _whiteBGView.backgroundColor = [UIColor whiteColor];
    }
    
    //原微博多图
    if (_model.pic_urls.count > 1) {
        _imageView.frame = CGRectZero;
        [_multiImagesView changePosition:CGPointMake(0, _textLabel.maxY)];
        _whiteBGView.frame = CGRectMake(GAP_15, GAP_10, self.contentView.width - GAP_15*2, _multiImagesView.height +  _textLabel.height+GAP_10);
    }
    
    //转发微博多图
    else if (_model.sinaRepost.pic_urls.count > 1){
        _imageView.frame = CGRectZero;
        [_textLabel changePosition:CGPointMake(GAP_5, GAP_20)];
        [_multiImagesView changePosition:CGPointMake(0, _textLabel.maxY)];
        _whiteBGView.frame = CGRectMake(GAP_15, + _repostTitle.maxY +GAP_10, self.contentView.width - GAP_15*2, _multiImagesView.height +  _textLabel.height+GAP_20 + 3);
    }
    
    //非多图
    else {
        
        //原图
        if (_model.bmiddle_pic) {
            _imageView.frame = CGRectMake(1, _textLabel.height+GAP_10, self.contentView.width - GAP_15 * 2 - 2, imageViewHeight);
            _whiteBGView.frame = CGRectMake(GAP_15, GAP_10, self.contentView.width - GAP_15*2, _imageView.height +  _textLabel.height+GAP_10);
        }
        
        //转发图
        else if (_model.sinaRepost.bmiddle_pic) {
            [_textLabel changePosition:CGPointMake(GAP_5, GAP_20)];
            _imageView.frame = CGRectMake(2, _textLabel.maxY, self.contentView.width - GAP_15 * 2 - 2*2, imageViewHeight);
            _whiteBGView.frame = CGRectMake(GAP_15, _repostTitle.maxY + GAP_10, self.contentView.width - GAP_15*2, _imageView.height +  _textLabel.height + GAP_20 + 3);
        }
        
        //无图
        else {
            
            //转发
            if (_model.sinaRepost) {
                [_textLabel changePosition:CGPointMake(GAP_5, GAP_20)];
                _imageView.frame = CGRectMake(0, 0, 0, 0);
                _whiteBGView.frame = CGRectMake(GAP_15, _repostTitle.maxY + GAP_10, self.contentView.width - GAP_15*2, _textLabel.height + GAP_20 + 3);
            }
            
            //原文
            else {
                [_textLabel changePosition:CGPointMake(GAP_5, GAP_10)];
                _imageView.frame = CGRectMake(0, 0, 0, 0);
                _whiteBGView.frame = CGRectMake(GAP_15, _repostTitle.maxY + GAP_10, self.contentView.width - GAP_15*2, _textLabel.height + GAP_10);
            }
        }
        
    }
    
    [_pinCountImageView changePosition:CGPointMake(GAP_15, _whiteBGView.maxY + GAP_10)];
    _pinNumberLabel.center = CGPointMake(_pinCountImageView.minX + _pinCountImageView.width + _pinNumberLabel.width / 2, _pinCountImageView.centerY);
    _pinNumberLabel.frame = CGRectMake(_pinCountImageView.maxX, _pinCountImageView.minY, _pinNumberLabel.width, _pinCountImageView.height);
    [_zfCountImageVIew changePosition:CGPointMake(GAP_15 + _pinCountImageView.width + _pinNumberLabel.width + 10, _whiteBGView.maxY + GAP_10)];
    _zfNumberLabel.center = CGPointMake(_zfCountImageVIew.minX + _zfCountImageVIew.width  + _zfNumberLabel.width / 2, _zfCountImageVIew.centerY);
    _zfNumberLabel.frame = CGRectMake(_zfCountImageVIew.maxX, _zfCountImageVIew.minY, _zfNumberLabel.width, _zfCountImageVIew.height);
    _pinTimeLabel.center = CGPointMake(self.contentView.width - GAP_15 - _pinTimeLabel.width / 2, _pinNumberLabel.centerY);
    _pinTimeLabel.frame = CGRectMake(self.contentView.width - GAP_15 - _pinTimeLabel.width, _pinCountImageView.origin.y, _pinTimeLabel.width, _pinTimeLabel.height);
    
    
    [_userIconImageView changePosition:CGPointMake(GAP_15,  _whiteBGView.maxY + GAP_40)];
    _userIconCover.center = _userIconImageView.center;
    
    _userIconBGImageView.center = _userIconImageView.center;
    [_userNameLabel changePosition:CGPointMake(GAP_15+ GAP_5 + _userIconImageView.width, _whiteBGView.maxY + GAP_50)];
    [_pinButton changePosition:CGPointMake(self.contentView.width - GAP_15 - _pinButton.width + 2, _whiteBGView.maxY + GAP_40)];
    
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
        
        _repostTitle = [[OHAttributedLabel alloc] init];
        _repostTitle.delegate = self;
        _repostTitle.numberOfLines = 0;
        _repostTitle.textColor = P6_COLOR;
        _repostTitle.font = TB_18_FONT;
        _repostTitle.backgroundColor = [UIColor clearColor];
        _repostTitle.textAlignment = UITextAlignmentLeft;
        _repostTitle.lineBreakMode = UILineBreakModeWordWrap;
        
        _pinNumberLabel = [[UILabel alloc] init];
        _pinNumberLabel.backgroundColor = [UIColor clearColor];
        _pinNumberLabel.font = T12_FONT;
        _pinNumberLabel.textColor = P9_COLOR;
        
        _zfNumberLabel = [[UILabel alloc] init];
        _zfNumberLabel.backgroundColor = [UIColor clearColor];
        _zfNumberLabel.font = T12_FONT;
        _zfNumberLabel.textColor = P9_COLOR;
        
        _pinTimeLabel = [[UILabel alloc] init];
        _pinTimeLabel.textAlignment = UITextAlignmentCenter;
        _pinTimeLabel.backgroundColor = [UIColor clearColor];
        _pinTimeLabel.textColor = P9_COLOR;
        _pinTimeLabel.font = T12_FONT;
        
        _whiteBGView = [[UIImageView alloc] init];
        _whiteBGView.userInteractionEnabled = YES;
        
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
        _userNameLabel.textColor = P7_COLOR;
        _userNameLabel.font = T14_FONT;
        
        _pinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pinButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _pinButton.frame = CGRectMake(0, 0, 32, 32);
        [_pinButton setImage:[UIImage imageNamed:@"btn_p_normal.png"] forState:UIControlStateNormal];
        [_pinButton setImage:[UIImage imageNamed:@"btn_p_pressed.png"] forState:UIControlStateHighlighted];
        
        _multiImagesView = [[UIView alloc] init];
        _multiImagesArray = [[NSMutableArray alloc] init];
        _urls = [[NSMutableArray alloc] init];
        
        [self.contentView addSubview:_repostTitle];
        [self.contentView addSubview:_whiteBGView];
        [_whiteBGView addSubview:_imageView];
        [_whiteBGView addSubview:_textLabel];
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

- (void)openWithUrl:(UITapGestureRecognizer *)tap
{
    if (_delegate && [_delegate respondsToSelector:@selector(gotoPersonWith:)]) {
        [_delegate gotoPersonWith:_model.sinaUser];
    }
}

-(BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel shouldFollowLink:(NSTextCheckingResult *)linkInfo
{
    if ([_delegate respondsToSelector:@selector(openWeiboWithUrl:)]) {
        [_delegate openWeiboWithUrl:[linkInfo.URL absoluteString]];
    }    
    return NO;
}

@end