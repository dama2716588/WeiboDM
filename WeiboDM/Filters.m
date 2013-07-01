//
//  Filters.m
//  notebook
//
//  Created by Stephen Liu on 12-8-30.
//  Copyright (c) 2012年 ifuninfo. All rights reserved.
//

#import "Filters.h"
#import "GPUImage.h"

@implementation GHGPUImageFilterLine
@synthesize filterType = _filterType;
- (void)dealloc{
    [self.input removeAllTargets];
    [super dealloc];
}

- (id)initWithType:(GHFilterType)type Input:(GPUImageOutput *)input output:(id<GPUImageInput>)output{
    self = [self init];
    if (self) {
        self.input = input;
        self.output = output;
        self.filters = [NSMutableArray array];
        self.filterType = type;
    }
    return self;
}

- (void)setFilterType:(GHFilterType)filterType{
    NSArray *newfilters = nil;
    if (filterType!=_filterType) {
        _filterType = filterType;
        [self.filters removeAllObjects];
        switch (filterType) {
            case GHFilterType1:{
                GPUImageToneCurveFilter *toneCurveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"crossprocess.acv"];
                newfilters = @[toneCurveFilter];
                [toneCurveFilter release];
            }break;
            case GHFilterType2:{
                GHLookupFilter *lookup = [[GHLookupFilter alloc] initwithImageName:@"anto2.jpg"];
                newfilters = @[lookup];
                [lookup release];
            }break;
            case GHFilterType3:{
                GHLookupFilter *lookup = [[GHLookupFilter alloc] initwithImageName:@"anto1.jpg"];
                newfilters = @[lookup];
                [lookup release];
            }break;
            case GHFilterType4:{
                GPUImageSaturationFilter *saturation = [[GPUImageSaturationFilter alloc] init];
                saturation.saturation = 0.5;
                
                GPUImageToneCurveFilter *toneCurveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"102.acv"];
                
                GPUImageBrightnessFilter *brightness = [[GPUImageBrightnessFilter alloc] init];
                brightness.brightness = -0.01;
                
                GPUImageContrastFilter *contrast = [[GPUImageContrastFilter alloc] init];
                contrast.contrast = 2.0f;
                
                GPUImageBoxBlurFilter *boxBlur = [[GPUImageBoxBlurFilter alloc] init];
                boxBlur.blurSize = 0.25;
                                
                GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
                [group addFilter:saturation];
                [group addFilter:brightness];
                [group addFilter:contrast];
                [group addFilter:boxBlur];
                [saturation addTarget:brightness];
                [brightness addTarget:contrast];
                [contrast addTarget:boxBlur];
                [group setInitialFilters:@[saturation]];
                group.terminalFilter = boxBlur;
                
                newfilters = @[group];
                [group release];
                [saturation release];
                [toneCurveFilter release];
                [brightness release];
                [contrast release];
                [boxBlur release];
            }break;
            case GHFilterType5:{
                GHLookupFilter *lookup = [[GHLookupFilter alloc] initwithImageName:@"怀旧.png"];
                newfilters = @[lookup];
                [lookup release];
            }break;
            case GHFilterType6:{
                GHLookupFilter *lookup = [[GHLookupFilter alloc] initwithImageName:@"纳什维尔.png"];
                GPUImageVignetteFilter *vigette = [[GPUImageVignetteFilter alloc] init];
                vigette.vignetteStart = 0.6;
                vigette.vignetteEnd = 0.8;
                newfilters = @[lookup,vigette];
                [vigette release];
                [lookup release];
            }break;
            case GHFilterType7:{
                GHLookupFilter *amatorka = [[GHLookupFilter alloc] initwithImageName:@"lookup_amatorka.png"];
                newfilters = @[amatorka];
                [amatorka release];
            }break;
            case GHFilterType8:{
                GHLookupFilter *lookup = [[GHLookupFilter alloc] initwithImageName:@"玫红色.png"];
                newfilters = @[lookup];
                [lookup release];
            }break;
            case GHFilterType9:{
                GHLookupFilter *lookup = [[GHLookupFilter alloc] initwithImageName:@"高光lomo.png"];
                newfilters = @[lookup];
                [lookup release];
            }break;
            case GHFilterType10:{
                GHLookupFilter *lookup = [[GHLookupFilter alloc] initwithImageName:@"巧克力圣代.png"];
                newfilters = @[lookup];
                [lookup release];
            }break;
            case GHFilterType11:{
                GPUImageMissEtikateFilter *missEtiate = [[GPUImageMissEtikateFilter alloc] init];
                newfilters = @[missEtiate];
                [missEtiate release];
            }break;
            case GHFilterType12:{
                GPUImageSoftEleganceFilter *softElegance = [[GPUImageSoftEleganceFilter alloc] init];
                newfilters = @[softElegance];
                [softElegance release];
            }break;
            case GHFilterType13:{
                GPUImageToneCurveFilter *toneCurveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"02.acv"];
                newfilters = @[toneCurveFilter];
                [toneCurveFilter release];
            }break;
            case GHFilterType14:{
                GPUImageToneCurveFilter *toneCurveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"17.acv"];
                newfilters = @[toneCurveFilter];
                [toneCurveFilter release];
            }break;
            case GHFilterType15:{
                GPUImageToneCurveFilter *toneCurveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"06.acv"];
                newfilters = @[toneCurveFilter];
                [toneCurveFilter release];
            }break;
            case GHFilterType16:{
                GPUImageToneCurveFilter *toneCurveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"aqua.acv"];
                newfilters = @[toneCurveFilter];
                [toneCurveFilter release];
            }break;
            case GHFilterType17:{
                GPUImageToneCurveFilter *toneCurveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"purple-green.acv"];
                newfilters = @[toneCurveFilter];
                [toneCurveFilter release];
            }break;
            case GHFilterType18:{
                GPUImageToneCurveFilter *toneCurveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"yellow-red.acv"];
                newfilters = @[toneCurveFilter];
                [toneCurveFilter release];
            }break;
            case GHFilterType19:{
                GPUImageToneCurveFilter *toneCurveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"101.acv"];
                newfilters = @[toneCurveFilter];
                [toneCurveFilter release];
            }break;
            case GHFilterType20:{
                GPUImageToneCurveFilter *toneCurveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"102.acv"];
                newfilters = @[toneCurveFilter];
                [toneCurveFilter release];
            }break;
            case GHFilterType21:{
                GPUImageToneCurveFilter *toneCurveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"103.acv"];
                newfilters = @[toneCurveFilter];
                [toneCurveFilter release];
            }break;
            case GHFilterType22:{
                GHLookupFilter *lookup = [[GHLookupFilter alloc] initwithImageName:@"墨水渲染.png"];
                newfilters = @[lookup];
                [lookup release];
            }break;
            case GHFilterType23:{
                GHLookupFilter *lookup = [[GHLookupFilter alloc] initwithImageName:@"流金岁月.png"];
                newfilters = @[lookup];
                [lookup release];
            }break;
            case GHFilterType24:{
                GHLookupFilter *lookup = [[GHLookupFilter alloc] initwithImageName:@"泛黄.png"];
                newfilters = @[lookup];
                [lookup release];
            }break;
            case GHFilterType25:{
                GHLookupFilter *lookup = [[GHLookupFilter alloc] initwithImageName:@"漫画书.png"];
                newfilters = @[lookup];
                [lookup release];
            }break;
            case GHFilterType26:{
                GHLookupFilter *lookup = [[GHLookupFilter alloc] initwithImageName:@"黑白卡通片.png"];
                newfilters = @[lookup];
                [lookup release];
            }break;
            case GHFilterType27:{
                GHLookupFilter *rosered = [[GHLookupFilter alloc] initwithImageName:@"细语.png"];
                newfilters = @[rosered];
                [rosered release];
            }break;
            case GHFilterType28:{
                GHLookupFilter *earlybird = [[GHLookupFilter alloc] initwithImageName:@"棕榈.png"];
                newfilters = @[earlybird];
                [earlybird release];
            }break;
            case GHFilterType29:{
                GPUImageGrayscaleFilter *grayscaleFilter = [[GPUImageGrayscaleFilter alloc] init];
                newfilters = @[grayscaleFilter];
                [grayscaleFilter release];
            }break;
            case GHFilterType30:{
                GPUImageSketchFilter *sketch = [[GPUImageSketchFilter alloc] init];
                newfilters = @[sketch];
                [sketch release];
            }break;
            case GHFilterType31:{
                GPUImageColorInvertFilter *colorInvert = [[GPUImageColorInvertFilter alloc] init];
                newfilters = @[colorInvert];
                [colorInvert release];
            }break;
            case GHFilterType32:{
                GPUImagePolkaDotFilter *polkaDot = [[GPUImagePolkaDotFilter alloc] init];
                polkaDot.fractionalWidthOfAPixel = 0.01;
                newfilters = @[polkaDot];
                [polkaDot release];
            }break;
            case GHFilterType33:{
                GPUImageCrosshatchFilter *croosshatch = [[GPUImageCrosshatchFilter alloc] init];
                croosshatch.crossHatchSpacing = 0.01;
                newfilters = @[croosshatch];
                [croosshatch release];
            }break;
            case GHFilterType34:{
                GPUImageSobelEdgeDetectionFilter *sobelEdgeDetection = [[GPUImageSobelEdgeDetectionFilter alloc] init];
                newfilters = @[sobelEdgeDetection];
                [sobelEdgeDetection release];
            }break;
            case GHFilterType35:{
                GPUImageEmbossFilter *emboss = [[GPUImageEmbossFilter alloc] init];
                emboss.intensity = 2;
                newfilters = @[emboss];
                [emboss release];
            }break;
            default:
                break;
        }
    }
    [self addFilters:newfilters];
}

- (void) _refreshFilters {
    if (self.filters.count==0) {
        GPUImageRGBFilter *defaultFilter = [[GPUImageRGBFilter alloc] init];
        [self addFilter:defaultFilter];
        [defaultFilter release];
        return;
    }
    __block id target = self.output;
    [self.filters enumerateObjectsWithOptions:NSEnumerationReverse
                                   usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                       [obj removeAllTargets];
                                       [obj addTarget:target];
                                       target = obj;
                                   }];
    [self.input removeAllTargets];
    
    GPUImageRotationMode imageViewRotationMode = kGPUImageNoRotation;
    switch (self.input.orientation) {
        case UIImageOrientationLeft:
            imageViewRotationMode = kGPUImageRotateLeft;
            break;
        case UIImageOrientationRight:
            imageViewRotationMode = kGPUImageRotateRight;
            break;
        case UIImageOrientationDown:
            imageViewRotationMode = kGPUImageRotate180;
            break;
        default:
            imageViewRotationMode = kGPUImageNoRotation;
            break;
    }
    [self.output setInputRotation:imageViewRotationMode atIndex:0];
    [self.input addTarget:target];
}
@end


@implementation GHLookupFilter

- (void)dealloc{
    [lookupFilter release];
    [picture release];
    [super dealloc];
}

- (id)initwithImageName:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    return [self initWithImage:image];
}

- (id)initWithImage:(UIImage *)image{
    self = [self init];
    if (self) {
        lookupFilter = [[GPUImageLookupFilter alloc] init];
        [self addFilter:lookupFilter];
        self.initialFilters = @[lookupFilter];
        self.terminalFilter = lookupFilter;
        [self setLookupImage:image];
    }
    return self;
}

- (void)setLookupImage:(UIImage *)image{
    [picture removeAllTargets];
    [picture release];
    picture = [[GPUImagePicture alloc] initWithImage:image];
    [picture addTarget:lookupFilter atTextureLocation:1];
    [picture processImage];
}
@end