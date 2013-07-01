//
//  WeiboCommentCell.h
//  pento
//
//  Created by ma yulong on 13-5-13.
//  Copyright (c) 2013年 Pento. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaCommentsModel.h"

@protocol WeiboCommentCellDelegate <NSObject>

- (void)clickedUserIcon:(SinaUserModel *)sinaUser;

@end

@interface WeiboCommentCell : UITableViewCell

@property (nonatomic, assign) id <WeiboCommentCellDelegate> delegate;

-(void)updateCellWithComment:(SinaCommentsModel *)comment;
+ (float)getCellHeight:(SinaCommentsModel *)model;
@end
