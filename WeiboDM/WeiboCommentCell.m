//
//  WeiboCommentCell.m
//  pento
//
//  Created by ma yulong on 13-5-13.
//  Copyright (c) 2013年 Pento. All rights reserved.
//

#import "WeiboCommentCell.h"
#import "SinaUserModel.h"
#import <QuartzCore/QuartzCore.h>

#define sinaWeiboMaxTextHeight 220

@implementation WeiboCommentCell {
    UIImageView *_userAvatarView;
    UIView *_commentBGView;
    UILabel *_lblUserName;
    UILabel *_lblCommentText;
    UILabel *_lblTime;
    SinaCommentsModel *_model;
    
    UIView *_lineView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _userAvatarView = [[UIImageView alloc] init];
        _userAvatarView.layer.cornerRadius = 25;
        _userAvatarView.clipsToBounds = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPerson:)];
        _userAvatarView.userInteractionEnabled = YES;
        [_userAvatarView addGestureRecognizer:tap];
        
        _lblUserName = [[UILabel alloc] init];
        _lblUserName.backgroundColor = [UIColor clearColor];
        _lblUserName.font = TB_16_FONT;
        _lblUserName.textColor = P6_COLOR;
        
        _lblCommentText = [[UILabel alloc] init];
        _lblCommentText.backgroundColor = [UIColor clearColor];
        _lblCommentText.font = T14_FONT;
        _lblCommentText.textColor = P5_COLOR;        
        _lblCommentText.numberOfLines = 0;
        _lblCommentText.lineBreakMode = UILineBreakModeWordWrap;
        
        
        _lblTime = [[UILabel alloc] init];
        _lblTime.backgroundColor = [UIColor clearColor];
        _lblTime.font = T14_FONT;
        _lblTime.textColor = P5_COLOR;
        
        _commentBGView  = [[UIView alloc] init];
        _commentBGView.backgroundColor = [UIColor colorWithRed:228/255.0f green:228/255.0f blue:228/255.0f alpha:1.0f];
        _commentBGView.layer.cornerRadius = 2;
        [_commentBGView addSubview:_lblCommentText];
        [_commentBGView addSubview:_lblTime];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithRed:228/255.0f green:228/255.0f blue:228/255.0f alpha:1.0f];
        
        [self.contentView addSubview:_lblUserName];        
        [self.contentView addSubview:_userAvatarView];
        [self.contentView addSubview:_commentBGView];
        [self.contentView addSubview:_lineView];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize size = [[self class] getTextLabelSize:_model];    
    _userAvatarView.frame = CGRectMake(GAP_10, GAP_10, 50, 50);
    _lblTime.frame = CGRectMake(self.width - 60, 0, 100, 20);
    _lblUserName.frame = CGRectMake(70, 10, 160, 20);
    _lblCommentText.frame = CGRectMake(10, 10, 220, size.height);
    _commentBGView.frame = CGRectMake(_userAvatarView.maxX + GAP_10 , GAP_30, 240, _lblCommentText.maxY+GAP_10);
    _lineView.frame = CGRectMake(0, self.height-1, 320, 1);
}

- (void)gotoPerson:(UITapGestureRecognizer *)tap
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickedUserIcon:)]) {
        [_delegate clickedUserIcon:_model.sinaUser];
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

- (void)updateCellWithComment:(SinaCommentsModel *)comment {
    
    _model = comment;    
    NSString *titleStr = comment.text;
    NSString *subTitle;
    if(titleStr.length > 140){
        subTitle = [titleStr substringToIndex:140];}
    else {
        subTitle = titleStr;
    }
    
    [_userAvatarView setImageWithURL:[NSURL URLWithString:comment.sinaUser.profile_image_url]];
    _lblUserName.text = comment.sinaUser.name;
    _lblTime.text = [Helper getPinTimeString:[self getFormatString:comment.created_at]];
    _lblCommentText.text = subTitle;
    
    [self setNeedsLayout];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (CGSize)getTextLabelSize:(SinaCommentsModel *)model {
    CGSize size = CGSizeMake(240, sinaWeiboMaxTextHeight);
    return [model.text sizeWithFont:T14_FONT
                  constrainedToSize:size
                      lineBreakMode:UILineBreakModeWordWrap];
}

+ (float)getCellHeight:(SinaCommentsModel *)model
{
    CGSize contentSize = [self getTextLabelSize:model];    
    return contentSize.height + 60;
}

@end
