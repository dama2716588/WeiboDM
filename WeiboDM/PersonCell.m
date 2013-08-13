//
//  PersonCell.m
//  WeiboDM
//
//  Created by ma yulong on 13-6-16.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import "PersonCell.h"
#import "ImageDisplayController.h"

#define BOOK_COVER_LR 10 //控制左右间隔
#define BOOK_COVER_UD 10 //控制上下间隔
#define COVER_WIDTH 50
#define COVER_HEIGHT 50
#define FIRST_COVER_MARGIN 0

@interface PersonCell()  //test_branch

@property (nonatomic, assign) CGFloat imageScale;
@property (nonatomic, assign) CGFloat repostImageScale;

@end

@implementation PersonCell
{
    OHAttributedLabel *_originLabel;
    UIImageView *_originImageView;
    UIView *_repostBg;
    OHAttributedLabel *_repostLabel;
    UIImageView *_repostImageView;
    SinaWeiboModel *_SinaWeiboModel;
    UIView *_lineView;
    
    UIButton *_pinButton;
    UIButton *_zhuanButton;
    UILabel *_pinLable;
    UILabel *_zhuanLabel;
    UILabel*_timeLable;
//    CGFloat imageScale;
//    CGFloat repostImageScale;
    
    CGFloat _lastWidth;
    CGFloat _coverHeight;
    UIView *_multiImagesView;
    
    NSMutableArray *_multiImagesArray;
    NSArray *_urls;
    int _currentPreview;
    
    ImageDisplayController *_imageDisplayController;
    NSMutableArray *_imageUrls;
    NSMutableArray *_preImages;    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self showUI];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showUI
{
    _originLabel = [[OHAttributedLabel alloc] init];
    _originLabel.delegate = self;
    _originLabel.numberOfLines = 0;
    _originLabel.backgroundColor = [UIColor clearColor];
    _originLabel.textColor = [UIColor blackColor];    
    
    _originImageView = [[UIImageView alloc] init];
    _originImageView.backgroundColor = [UIColor clearColor];
    [_originImageView setClipsToBounds:YES];
    _originImageView.contentMode = UIViewContentModeScaleAspectFill;

    _originImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
    [_originImageView addGestureRecognizer:tapImage];
        
    _repostBg = [[UIView alloc] init];
    _repostBg.backgroundColor = [UIColor colorWithRed:228/255.0f green:228/255.0f blue:228/255.0f alpha:1.0f];
    _repostBg.layer.cornerRadius = 2;
    
    _repostLabel = [[OHAttributedLabel alloc] init];
    _repostLabel.delegate = self;
    _repostLabel.numberOfLines = 0;
    _repostLabel.backgroundColor = [UIColor clearColor];
    _repostLabel.textColor = [UIColor blackColor];

    _repostImageView = [[UIImageView alloc] init];
    _repostImageView.backgroundColor = [UIColor clearColor];
    [_repostImageView setClipsToBounds:YES];
    _repostImageView.userInteractionEnabled = YES;
    _repostImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1.0];
    
    _pinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_pinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_pinButton setBackgroundImage:[UIImage imageNamed:@"pinglun_small_icon.png"] forState:UIControlStateNormal];
    
    _zhuanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_zhuanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_zhuanButton setBackgroundImage:[UIImage imageNamed:@"zhuanfa_small_icon.png"] forState:UIControlStateNormal];
    
    _pinLable = [[UILabel alloc] init];
    _zhuanLabel = [[UILabel alloc] init];
    _pinLable.backgroundColor = [UIColor clearColor];
    _zhuanLabel.backgroundColor = [UIColor clearColor];
    _pinButton.layer.cornerRadius = 10;
    _zhuanButton.layer.cornerRadius = 10;
    _pinButton.clipsToBounds = YES;
    _zhuanButton.clipsToBounds = YES;
    _pinLable.textColor = [UIColor lightGrayColor];
    _zhuanLabel.textColor = [UIColor lightGrayColor];
    
    _timeLable = [[UILabel alloc] init];
    _timeLable.backgroundColor = [UIColor clearColor];
    _timeLable.textColor = [UIColor lightGrayColor];
    _timeLable.font = T12_FONT;
    
    _multiImagesView = [[UIView alloc] init];
    _multiImagesArray = [[NSMutableArray alloc] init];
    
    _preImages = [[NSMutableArray alloc] init];
    _imageUrls = [[NSMutableArray alloc] init];
    
    [self addSubview:_originLabel];
    [self addSubview:_originImageView];
    [self addSubview:_repostBg];
    [self addSubview:_lineView];
    [self addSubview:_pinButton];
    [self addSubview:_zhuanButton];
    [self addSubview:_pinLable];
    [self addSubview:_zhuanLabel];
    [self addSubview:_timeLable];
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

- (void)clickImage:(UITapGestureRecognizer *)tap{}

- (void)clickRepostImage:(UITapGestureRecognizer *)tap{}

-(void)updateCellWithData:(SinaWeiboModel *)model
{
    
    _SinaWeiboModel = model;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:_SinaWeiboModel.text];
    [text setFont:T16_FONT];
    _originLabel.attributedText = text;
    
    if (_SinaWeiboModel.sinaRepost.text) {
        NSMutableAttributedString *textR = [[NSMutableAttributedString alloc] initWithString:_SinaWeiboModel.sinaRepost.text];
        [textR setFont:T14_FONT];
        _repostLabel.attributedText = textR;
    }
    
    
    __weak __block PersonCell *selfRef = self;
    __weak __block UIImageView *_originImageViewRef = _originImageView;
    __weak __block UIImageView *_repostImageViewRef = _repostImageView;
        
    [_originImageView setImageWithURL:[NSURL URLWithString:_SinaWeiboModel.bmiddle_pic]
                            completed:^(UIImage *image,NSError *error,SDImageCacheType type){
                                selfRef.imageScale = 100/image.size.height;
                                _originImageViewRef.image = image;
                                [selfRef setNeedsLayout];
    }];
    
    [_repostImageView setImageWithURL:[NSURL URLWithString:_SinaWeiboModel.sinaRepost.bmiddle_pic]
                            completed:^(UIImage *image,NSError *error,SDImageCacheType type){
                                 selfRef.repostImageScale = 80/image.size.height;
                                _repostImageViewRef.image = image;
                                [selfRef setNeedsLayout];
                            }];
    
    if (_SinaWeiboModel.sinaRepost.text) {
        [_repostBg addSubview:_repostLabel];
    }
    
    if (_SinaWeiboModel.sinaRepost.bmiddle_pic) {
        [_repostBg addSubview:_repostImageView];        
        UITapGestureRecognizer *repostImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickRepostImage:)];
        [_repostImageView addGestureRecognizer:repostImage];
    }
    
    _pinLable.text = [NSString stringWithFormat:@"%d",_SinaWeiboModel.comments_count];
    _zhuanLabel.text = [NSString stringWithFormat:@"%d",_SinaWeiboModel.reposts_count];
    [_pinLable sizeToFit];
    [_zhuanLabel sizeToFit];
    
    _timeLable.text = [self getFormatString:_SinaWeiboModel.created_at];
    [_timeLable sizeToFit];
    
    //add multi images
    SinaWeiboModel *originModel = model.pic_urls.count >1 ? model : model.sinaRepost;
    if (originModel.pic_urls.count > 1) {
        [self createMultiImagesView:originModel];
        originModel.bmiddle_pic = nil;
    }
    
    if (model.pic_urls.count > 1 ) {
        [self addSubview:_multiImagesView];
    } else if (model.sinaRepost.pic_urls.count > 1) {
        [_repostBg addSubview:_multiImagesView];
    } else {}
    
    [self setNeedsLayout];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize repostSize = CGSizeZero;
    CGSize textSize = CGSizeZero;
    
    if(_SinaWeiboModel.text){
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:_SinaWeiboModel.text];
        [text setFont:T16_FONT];
        textSize = [text sizeConstrainedToSize:CGSizeMake(self.width - GAP_20, 300)];
    }
    
    if(_SinaWeiboModel.sinaRepost.text){
        NSMutableAttributedString *retext = [[NSMutableAttributedString alloc] initWithString:_SinaWeiboModel.sinaRepost.text];
        [retext setFont:T14_FONT];
        repostSize = [retext sizeConstrainedToSize:CGSizeMake(self.width - GAP_40, 360)];
    }
    
    _originLabel.frame = CGRectMake(10, 10, 300, textSize.height);
    
    CGFloat w1 = (self.width-GAP_20) * self.imageScale < self.width-GAP_20 ? (self.width-GAP_20) * self.imageScale : self.width-GAP_20;
    
    if (_SinaWeiboModel.bmiddle_pic) {
        _originImageView.frame = CGRectMake(GAP_10, GAP_10 + _originLabel.maxY , w1, 100);
    } else {
        _originImageView.frame = CGRectZero;
    }
        
    if(_SinaWeiboModel.sinaRepost.text){
        _repostLabel.frame = CGRectMake(GAP_10, GAP_10, self.width-GAP_40, repostSize.height);
    } else {
        _repostLabel.frame = CGRectZero;
    }
    
    CGFloat w2 = 280*self.repostImageScale < 280 ? 280*self.repostImageScale : 280;
    
    if (_SinaWeiboModel.sinaRepost.bmiddle_pic){
        _repostImageView.frame = CGRectMake(GAP_10, _repostLabel.height + GAP_20, w2,80);
    } else {
        _repostImageView.frame = CGRectZero;
    }
    
    if (_SinaWeiboModel.sinaRepost) {
        CGFloat gapH = _SinaWeiboModel.sinaRepost.bmiddle_pic ? GAP_20 : GAP_10;
        _repostBg.frame = CGRectMake(GAP_10, _originLabel.maxY + GAP_10, 300, _repostLabel.maxY + _repostImageView.height + gapH);
    } else {
        _repostBg.frame = CGRectZero;
    }
    
    if (_SinaWeiboModel.pic_urls.count >1) {
        [_multiImagesView changePosition:CGPointMake(10, _originLabel.maxY + 10)];
    }
    
    if (_SinaWeiboModel.sinaRepost.pic_urls.count > 1) {
        [_multiImagesView changePosition:CGPointMake(10, _repostLabel.maxY + 10)];
        _repostBg.frame = CGRectMake(_repostBg.origin.x, _repostBg.origin.y, _repostBg.width, _repostBg.height + _multiImagesView.height + 10);
    }
    
    _pinButton.frame = CGRectMake(10, self.height - GAP_40, 20, 20);
    _pinLable.center = CGPointMake(_pinButton.maxX + _pinLable.width/2 + GAP_10, _pinButton.centerY);
    _zhuanButton.frame = CGRectMake(_pinLable.maxX + GAP_20, self.height - GAP_40, 20, 20);
    _zhuanLabel.center = CGPointMake(_zhuanButton.maxX + _zhuanLabel.width/2 + GAP_10, _zhuanButton.centerY);
    _timeLable.frame = CGRectMake(180, self.height - GAP_40, 160, 20);
    
    _lineView.frame = CGRectMake(0, self.height-1, 320, 1);
}

- (void)createMultiImagesView:(SinaWeiboModel *)model
{    
    NSArray *urlsArray = model.pic_urls;
    _urls = urlsArray;
    CGFloat h = [[self class] getMultiImageHeight:model];
    
    _multiImagesView.frame = CGRectMake(0, 0, 170, h);
    
    _lastWidth = FIRST_COVER_MARGIN;
    _coverHeight = 0;
    
    for (int j=0; j<urlsArray.count; j++)
    {
        if (_lastWidth + COVER_WIDTH > 200)
        {
            _lastWidth = FIRST_COVER_MARGIN;
            _coverHeight += BOOK_COVER_UD + COVER_WIDTH ;
        }
        
        NSString *thumbnailUrl = [[urlsArray objectAtIndex:j] objectForKey:@"thumbnail_pic"];
        NSString *largeUrl = [thumbnailUrl stringByReplacingOccurrencesOfString:@"/thumbnail" withString:@"/large"];
        [_imageUrls addObject:largeUrl];
        
        UIImageView *bookCover = [[UIImageView alloc] init];        
        [bookCover setImageWithURL:[NSURL URLWithString:[[urlsArray objectAtIndex:j] objectForKey:@"thumbnail_pic"]]];
        bookCover.contentMode = UIViewContentModeScaleAspectFill;
        bookCover.clipsToBounds = YES;
        bookCover.frame = CGRectMake(_lastWidth, _coverHeight, COVER_WIDTH, COVER_HEIGHT);
        bookCover.backgroundColor = [UIColor whiteColor];
        bookCover.userInteractionEnabled = YES;
        bookCover.tag = j;
        [_multiImagesView addSubview:bookCover];
        _lastWidth += COVER_WIDTH + BOOK_COVER_LR;
        
        if (bookCover.image) {
            [_preImages addObject:bookCover.image];
        }        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSmallImage:)];
        [bookCover addGestureRecognizer:tap];
        [_multiImagesArray addObject:bookCover];
    }    
}

- (void)clickSmallImage:(UITapGestureRecognizer *)tap
{
    int index = [[tap view] tag];    
    
    if (_delegate && [_delegate respondsToSelector:@selector(openSmallImages:preImages:andCurrentIndex:)]) {
        [_delegate openSmallImages:_imageUrls preImages:_preImages andCurrentIndex:index];
    }
}

//- (void)clickSmallImage:(UITapGestureRecognizer *)tap
//{
//    UIImageView *clickedImage = (UIImageView *)[tap view];
//    _currentPreview = clickedImage.tag;
//    NSLog(@"_currentPreview : %d",_currentPreview);
//    
//    UIWindow *window = [[UIApplication sharedApplication] keyWindow];        
//    ScrollWebImageView *sw = [[ScrollWebImageView alloc] initWithFrame:window.bounds withUrls:_urls andPreImages:_multiImagesArray];
//    sw.clickedIndex = _currentPreview;
//    [sw showFromView:clickedImage];
//}

+ (float)getMultiImageHeight:(SinaWeiboModel *)model
{
    SinaWeiboModel *originModel = model.sinaRepost ? model.sinaRepost : model;
    
    if (originModel.pic_urls.count <= 1) {
        return 0;
    }
    
    if (originModel.pic_urls.count <= 3) {
        return 50;
    }
    
    if (originModel.pic_urls.count <= 6) {
        return 110;
    }
    
    return 170;
}

+ (float)calculateCardHeight:(SinaWeiboModel *)model
{
    SinaWeiboModel *originModel = model.sinaRepost ? model.sinaRepost : model;
    if (originModel.pic_urls.count > 1) {
        originModel.bmiddle_pic = nil;
    }    
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:model.text];
    [text setFont:T16_FONT];    
    CGSize textSize = [text sizeConstrainedToSize:CGSizeMake(320 - GAP_20, 300)];    
    
    NSMutableAttributedString *retext;
    CGSize repostSize;
    if(model.sinaRepost.text){
       retext = [[NSMutableAttributedString alloc] initWithString:model.sinaRepost.text];
       [retext setFont:T14_FONT];
       repostSize = [retext sizeConstrainedToSize:CGSizeMake(320 - GAP_40, 360)];
    } else {
        repostSize = CGSizeZero;
    }
    
    CGFloat h0 = 0;
    if (model.bmiddle_pic) {
        h0 = 100 + GAP_10;
    }
    
    CGFloat h1 = 0;
    if (model.sinaRepost.bmiddle_pic) {
        h1 = 80;
    }
    
    CGFloat h2 = textSize.height > 0 ? textSize.height + GAP_10 : 0;
    CGFloat h3 = repostSize.height > 0 ? repostSize.height : 0;
    
    CGFloat gap1 = 0;
    if (model.sinaRepost.text && !model.sinaRepost.bmiddle_pic) {
        gap1 = GAP_30;
    } else if (model.sinaRepost.text && model.sinaRepost.bmiddle_pic) {
        gap1 = GAP_40;
    } else {
        gap1 = 0;
    }
    
    CGFloat multiH = [[self class] getMultiImageHeight:model];
    CGFloat gap2 = multiH > 0 ? GAP_10 : 0;
    
    return h0 + h1 + h2 + h3 + gap1 + GAP_30*2 + multiH + gap2;
}

@end
