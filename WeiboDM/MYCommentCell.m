//
//  MYCommentCell.m
//  WeiboDM
//
//  Created by ma yulong on 13-6-13.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import "MYCommentCell.h"

@implementation MYCommentCell
{
    SinaCommentsModel *_model;
    UIImageView *_iconImage;
    UILabel *_nameLabel;
    UILabel *_commentLabel;
    UILabel *_fromLabel;
    UILabel *_timeLabel;
    UIView *_lineView;
}

+ (CGFloat)heightForCell:(SinaCommentsModel *)model
{
    CGSize size = [self getTextLabelSize:model];
    return 120 + size.height;
}

+ (CGSize)getTextLabelSize:(SinaCommentsModel *)model {
    CGSize size = CGSizeMake(220, 100);
    return [model.text sizeWithFont:T14_FONT
                  constrainedToSize:size
                      lineBreakMode:UILineBreakModeWordWrap];
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
    _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    _iconImage.layer.cornerRadius = 25;
    _iconImage.clipsToBounds = YES;
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 100, 30)];
    _nameLabel.textColor = [UIColor lightGrayColor];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _commentLabel = [[UILabel alloc] init];
    _commentLabel.backgroundColor = [UIColor clearColor];
    _commentLabel.numberOfLines = 0;
    _fromLabel = [[UILabel alloc] init];
    _fromLabel.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0];
    _fromLabel.font = T12_FONT;
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor lightGrayColor];
    _timeLabel.font = T12_FONT;
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor lightGrayColor];
    
    [self addSubview:_iconImage];
    [self addSubview:_nameLabel];
    [self addSubview:_commentLabel];
    [self addSubview:_fromLabel];
    [self addSubview:_timeLabel];
    [self addSubview:_lineView];
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

- (void)updateDataWith:(SinaCommentsModel *)model
{
    _model = model;
    
    [_iconImage setImageWithURL:[NSURL URLWithString:_model.sinaUser.profile_image_url]];
    _nameLabel.text = _model.sinaUser.name;
    _commentLabel.text = _model.text;
    _fromLabel.text = _model.replyComment.text.length > 20 ? [_model.replyComment.text substringToIndex:20] : _model.sinaWeibo.text;
    _timeLabel.text = [self getFormatString:_model.created_at];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize commentSize = [[self class] getTextLabelSize:_model];
    
    _commentLabel.frame = CGRectMake(70, _nameLabel.maxY, 230, commentSize.height);
    _fromLabel.frame = CGRectMake(70, _commentLabel.maxY + GAP_10, 230, 30);
    _timeLabel.frame = CGRectMake(70, _fromLabel.maxY + GAP_10, 230, 30);
    _lineView.frame = CGRectMake(0, _timeLabel.maxY+1, 320, 1);
}


@end
