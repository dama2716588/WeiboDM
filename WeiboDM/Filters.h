//
//  Filters.h
//  notebook
//
//  Created by Stephen Liu on 12-8-30.
//  Copyright (c) 2012年 ifuninfo. All rights reserved.
//

#import "GPUImage.h"

typedef enum{
    GHFilterType1 = 1,
    GHFilterType2,
    GHFilterType3,
    GHFilterType4,
    GHFilterType5,
    GHFilterType6,
    GHFilterType7,
    GHFilterType8,
    GHFilterType9,
    GHFilterType10,
    GHFilterType11,
    GHFilterType12,
    GHFilterType13,
    GHFilterType14,
    GHFilterType15,
    GHFilterType16,
    GHFilterType17,
    GHFilterType18,
    GHFilterType19,
    GHFilterType20,
    GHFilterType21,
    GHFilterType22,
    GHFilterType23,
    GHFilterType24,
    GHFilterType25,
    GHFilterType26,
    GHFilterType27,
    GHFilterType28,
    GHFilterType29,
    GHFilterType30,
    GHFilterType31,
    GHFilterType32,
    GHFilterType33,
    GHFilterType34,
    GHFilterType35,
    GHFilterType36,
    GHFilterType37,
    GHFilterType38,
    GHFilterType39,
    GHFilterType40,
    GHFilterType41,
    GHFilterType42
}GHFilterType;

@interface GHGPUImageFilterLine : GPUImageFilterPipeline
@property(nonatomic,assign)GHFilterType filterType;
- (id)initWithType:(GHFilterType)type Input:(GPUImageOutput *)input output:(id<GPUImageInput>)output;
@end

@interface GHLookupFilter : GPUImageFilterGroup{
    GPUImagePicture *picture;
    GPUImageLookupFilter *lookupFilter;
}
- (id)initwithImageName:(NSString *)imageName;
- (id)initWithImage:(UIImage *)image;
- (void)setLookupImage:(UIImage *)image;
@end