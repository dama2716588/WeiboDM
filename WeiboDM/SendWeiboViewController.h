//
//  SendWeiboViewController.h
//  WeiboDM
//
//  Created by ma yulong on 13-6-17.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTSinaWeiboClient.h"
#import "ImageFilterViewController.h"

@interface SendWeiboViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,SinaWeiboDelegate,SinaWeiboRequestDelegate,ImageFilterViewControllerDelegate>

@property(nonatomic,retain)UIImagePickerController *imagePicker;

@end
