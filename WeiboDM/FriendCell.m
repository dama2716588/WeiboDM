//
//  FriendCell.m
//  WeiboDM
//
//  Created by ma yulong on 13-6-14.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import "FriendCell.h"

@implementation FriendCell
{
    UIImageView *_iconImageView;
    UILabel *_nameLabel;
    UILabel *_cityLabel;
    SinaUserModel *_model;
    UIView *_lineView;
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
    _iconImageView = [[UIImageView alloc] init];
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor grayColor];
    _cityLabel = [[UILabel alloc] init];
    _cityLabel.backgroundColor = [UIColor clearColor];
    _cityLabel.textColor = [UIColor grayColor];
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor lightGrayColor];
    
    [self addSubview:_iconImageView];
    [self addSubview:_nameLabel];
    [self addSubview:_cityLabel];
    [self addSubview:_lineView];
}

-(void)updateDataWith:(SinaUserModel *)model
{
    _model = model;
    
    [_iconImageView setImageWithURL:[NSURL URLWithString:_model.profile_image_url]];
    _nameLabel.text = _model.name;
    _cityLabel.text = _model.location;
    
    [self setNeedsLayout]; 
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _iconImageView.frame = CGRectMake(10, 10, 50, 50);
    _iconImageView.layer.cornerRadius = 25;
    _iconImageView.clipsToBounds = YES;
    _nameLabel.frame = CGRectMake(70, 0, 200, 30);
    _cityLabel.frame = CGRectMake(70, 30, 200, 30);
    _lineView.frame = CGRectMake(0, 69, 320, 1);
}

@end
