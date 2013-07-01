//
//  MainViewController.h
//  WeiboDM
//
//  Created by ma yulong on 13-5-24.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTSinaWeiboClient.h"
#import "BaseViewController.h"
#import "UICollectionViewWaterfallLayout.h"
#import "PSTCollectionView.h"
#import "EGOViewCommon.h"
#import "SinaWeiboType.h"
#import "MBProgressHUD.h"
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
#import "SinaWeiboCell.h"

@interface MainViewController : BaseViewController <PSUICollectionViewDataSource,PSUICollectionViewDelegate,UICollectionViewDelegateWaterfallLayout,SinaWeiboDelegate,SinaWeiboRequestDelegate,EGORefreshTableDelegate,SinaWeiboCellDelegate,UIScrollViewDelegate>

@property(strong, nonatomic) PTSinaWeiboClient *sinaWeiboClient;

@property(strong, nonatomic) PSUICollectionView *collectionView;

- (id)initWithType:(SinaWeiboType *)type;
+ (float)cellWidth;
@end
