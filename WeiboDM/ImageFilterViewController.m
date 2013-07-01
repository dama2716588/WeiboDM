//
//  ImageFilterViewController.m
//  notebook
//
//  Created by Stephen Liu on 12-8-27.
//  Copyright (c) 2012年 ifuninfo. All rights reserved.
//

#import "ImageFilterViewController.h"
#import "GPUImage.h"
#import "GHScrollItemListView.h"
#import "Filters.h"
#import <MobileCoreServices/MobileCoreServices.h>

const NSString *kFilteredImage = @"kFilteredImage";

#define ListViewTag   1000

@interface ImageFilterViewController ()<GHScrollItemListViewDelegate>{
    GPUImageView *imageView;
    GPUImagePicture *staticPicture;
    GHGPUImageFilterLine  *_filterLine;
    GHFilterType filterType;
}
@property(nonatomic,retain)GHGPUImageFilterLine *filterLine;
@end

@implementation ImageFilterViewController
@synthesize originImage;
@synthesize filteredImage;
@synthesize filterLine = _filterLine;
@synthesize delegate = _delegate;

- (void)dealloc{
    [originImage release];
    [filteredImage release];
    [imageView release];
    [staticPicture release];
    [_filterLine release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Image Filter",nil);
        self.contentSizeForViewInPopover = CGSizeMake(320, 480);
        imageView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.fillMode = kGPUImageFillModePreserveAspectRatio;
        [imageView setBackgroundColorRed:0 green:0 blue:0 alpha:0];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (id)initWithImage:(UIImage *)image{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.originImage = image;
    }
    return self;
}

- (void)setOriginImage:(UIImage *)image{
    if (originImage!=image) {
        [filteredImage release];
        filteredImage = nil;
        [originImage release];
        originImage = [image retain];
        [staticPicture release];
        staticPicture = [[GPUImagePicture alloc] initWithImage:originImage
                                           smoothlyScaleOutput:NO];
        [staticPicture setOrientation:image.imageOrientation];
        [staticPicture processImage];
    }
}

- (void)filterImage{
    self.filterLine = [[[GHGPUImageFilterLine alloc] initWithType:filterType Input:staticPicture output:imageView] autorelease];    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self filterImage];
    self.filterLine.filterType = filterType;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    imageView.frame = self.view.bounds;
    [self.view addSubview:imageView];
        
    GHScrollItemListView *list = [[GHScrollItemListView alloc] initWithFrame:CGRectMake(0, self.view.height-90, self.view.width,90)];
    list.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    list.items = [NSArray arrayWithObjects:
                  @{@"image":@"filter_0.png",@"selectedImage":@"",@"title":NSLocalizedString(@"Normal",nil)},
                  @{@"image":@"filter_1.jpg",@"selectedImage":@"",@"title":NSLocalizedString(@"Lomo",nil)},
                  @{@"image":@"filter_2.jpg",@"selectedImage":@"",@"title":NSLocalizedString(@"Polaroid",nil)},
                  @{@"image":@"filter_3.jpg",@"selectedImage":@"",@"title":NSLocalizedString(@"Cyan",nil)},
                  @{@"image":@"filter_4.jpg",@"selectedImage":@"",@"title":NSLocalizedString(@"Sunset",nil)},
                  @{@"image":@"filter_5.jpg",@"selectedImage":@"",@"title":NSLocalizedString(@"Nostalgic",nil)},
                  @{@"image":@"filter_6.jpg",@"selectedImage":@"",@"title":NSLocalizedString(@"Nashville",nil)},
                  @{@"image":@"filter_7.jpg",@"selectedImage":@"",@"title":NSLocalizedString(@"Amatorka",nil)},
                  @{@"image":@"filter_8.jpg",@"selectedImage":@"",@"title":NSLocalizedString(@"Rose",nil)},
                  @{@"image":@"filter_9.jpg",@"selectedImage":@"",@"title":NSLocalizedString(@"H-Light",nil)},
                  @{@"image":@"filter_10.jpg",@"selectedImage":@"",@"title":NSLocalizedString(@"Sundae",nil)},
                  @{@"image":@"filter_11.jpg",@"selectedImage":@"",@"title":NSLocalizedString(@"Etikate",nil)},
                  @{@"image":@"filter_12.jpg",@"selectedImage":@"",@"title":NSLocalizedString(@"Moss",nil)},
                  @{@"image":@"filter_13.jpg",@"selectedImage":@"",@"title":NSLocalizedString(@"1990s",nil)},
                  @{@"image":@"filter_14.jpg",@"selectedImage":@"",@"title":NSLocalizedString(@"1980s",nil)},
                  @{@"image":@"filter_15.jpg",@"selectedImage":@"",@"title":NSLocalizedString(@"1970s",nil)},
                  @{@"image":@"filter_16.jpg",@"selectedImage":@"",@"title":NSLocalizedString(@"L-Green",nil)},
                  @{@"image":@"filter_17.jpg",@"selectedImage":@"",@"title":NSLocalizedString(@"Light",nil)},
                  @{@"image":@"filter_18.jpg",@"selectedImage":@"",@"title":NSLocalizedString(@"Tangerine",nil)},
                  @{@"image":@"filter_19.jpg",@"selectedImage":@"",@"title":NSLocalizedString(@"Afternoon",nil)},
                  @{@"image":@"filter_20.jpg",@"selectedImage":@"",@"title":NSLocalizedString(@"Bright",nil)},
                  @{@"image":@"filter_21.jpg",@"selectedImage":@"",@"title":NSLocalizedString(@"Green",nil)},
                  @{@"image":@"filter_22.jpg",@"selectedImage":@"",@"title":NSLocalizedString(@"Inkwell",nil)},
                  @{@"image":@"filter_23.jpg",@"selectedImage":@"",@"title":NSLocalizedString(@"Old Days",nil)},
                  @{@"image":@"filter_24.jpg",@"selectedImage":@"",@"title":NSLocalizedString(@"Yellowing",nil)},
                  @{@"image":@"filter_25.jpg",@"selectedImage":@"",@"title":NSLocalizedString(@"Comic",nil)},
                  @{@"image":@"filter_26.jpg",@"selectedImage":@"",@"title":NSLocalizedString(@"Cartoon",nil)},
                  @{@"image":@"filter_27.jpg",@"selectedImage":@"",@"title":NSLocalizedString(@"Whisper",nil)},
                  @{@"image":@"filter_28.jpg",@"selectedImage":@"",@"title":NSLocalizedString(@"Palm",nil)},
                  @{@"image":@"filter_29.jpg",@"selectedImage":@"",@"title":NSLocalizedString(@"B&W",nil)},
                  @{@"image":@"filter_30.jpg",@"selectedImage":@"",@"title":NSLocalizedString(@"Sketch",nil)},
                  @{@"image":@"filter_31.jpg",@"selectedImage":@"",@"title":NSLocalizedString(@"Negative",nil)},
                  @{@"image":@"filter_32.jpg",@"selectedImage":@"",@"title":NSLocalizedString(@"Lattice",nil)},
                  @{@"image":@"filter_33.jpg",@"selectedImage":@"",@"title":NSLocalizedString(@"Shadow",nil)},
                  @{@"image":@"filter_34.jpg",@"selectedImage":@"",@"title":NSLocalizedString(@"Engraving",nil)},
                  @{@"image":@"filter_35.jpg",@"selectedImage":@"",@"title":NSLocalizedString(@"Relief",nil)},nil];
    list.delegate = self;
    list.tag = ListViewTag;
    [self.view addSubview:list];
    [list release];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                               style:UIBarButtonItemStyleBordered
                                                                              target:self
                                                                              action:@selector(commit:)] autorelease];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"filterVC_didreceive_memorywarning");
}

- (void)commit:(id)sender{
    GHScrollItemListView *list = (GHScrollItemListView *)[self.view viewWithTag:ListViewTag];
    NSString *selectedFilter = [[list selectedItem] objectForKey:@"title"];
    if (selectedFilter) {
//        [MobClick event:EVENT_FILTERSELECTED label:selectedFilter];
    }
    UIImage *image = [_filterLine currentFilteredFrameWithOrientation:originImage.imageOrientation];
    if (!image) {
        return;
    }
    CGFloat scale = MIN(imageView.height/image.size.height,imageView.width/image.size.width);
    CGRect frame = CGRectMakeWithCenterAndSize(imageView.centerOfView, CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(scale, scale)));
    frame = [imageView convertRect:frame toView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
    if ([_delegate respondsToSelector:@selector(filterController:finishWithImageInfo:)]) {
        [_delegate filterController:self
                finishWithImageInfo:@{kFilteredImage:image,
   UIImagePickerControllerMediaType:(NSString *)kUTTypeImage,
         @"kFrameInWindow":[NSValue valueWithCGRect:frame]}];
    }
}

- (void)ScrollItemListView:(GHScrollItemListView *)listView didSelectItemAtIndex:(NSInteger)index{
    if (filterType == index) {
        return;
    }
    filterType = index;
    if ([UIDevice currentDevice].systemVersion.intValue < 5) {
        [imageView removeFromSuperview];
        [imageView release];
        
        imageView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.fillMode = kGPUImageFillModePreserveAspectRatio;
        [imageView setBackgroundColorRed:0 green:0 blue:0 alpha:0];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self.view insertSubview:imageView atIndex:0];
        self.filterLine.output = imageView;
    }
    self.filterLine.filterType = filterType;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
