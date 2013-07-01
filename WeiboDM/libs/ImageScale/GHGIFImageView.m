//
//  SCGIFImageView.m
//
//  Modified and BugFix by 诗彬 刘 from https://github.com/kasatani/AnimatedGifExample on 12-3-15
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//  
//

#import "GHGIFImageView.h"

@interface AnimatedGifFrame : NSObject{
	NSData *data;
	NSData *header;
	double delay;
	int disposalMethod;
	CGRect area;
}

@property (nonatomic, copy) NSData *header;
@property (nonatomic, copy) NSData *data;
@property (nonatomic) double delay;
@property (nonatomic) int disposalMethod;
@property (nonatomic) CGRect area;

@end

@implementation AnimatedGifFrame

@synthesize data, delay, disposalMethod, area, header;

- (void) dealloc
{
	[data release];
	[header release];
	[super dealloc];
}

@end

inline static NSData *GIFGetBytes(int length,int *dataPointer,NSData *gifData){
	if ((NSInteger)[gifData length] >= *dataPointer + length){
        NSData *data = [gifData subdataWithRange:NSMakeRange(*dataPointer, length)];
        *dataPointer += length;
		return data;
    }else{
        return nil;
    }
}

inline static BOOL GIFSkipBytes(int length,NSData *gifData,int *dataPointer){
    if ((NSInteger)[gifData length] >= *dataPointer + length){
        *dataPointer += length;
        return YES;
    }else{
    	return NO;
    }
}

inline static AnimatedGifFrame *GIFReadExtensions(NSData *gifData,int *dataPointer){
	// 21! But we still could have an Application Extension,
	// so we want to check for the full signature.
	unsigned char cur[1], prev[1];
    NSData *dataBuffer = GIFGetBytes(1, dataPointer, gifData);
    [dataBuffer getBytes:cur length:1];
    AnimatedGifFrame *frame = [[AnimatedGifFrame alloc] init];

	while (cur[0] != 0x00){
		// TODO: Known bug, the sequence F9 04 could occur in the Application Extension, we
		//       should check whether this combo follows directly after the 21.
		if (cur[0] == 0x04 && prev[0] == 0xF9){
            dataBuffer = GIFGetBytes(5, dataPointer, gifData);
			
			unsigned char buffer[5];
			[dataBuffer getBytes:buffer length:5];
			frame.disposalMethod = (buffer[0] & 0x1c) >> 2;
			
			frame.delay = (buffer[1] | buffer[2] << 8);
			
			unsigned char board[8];
			board[0] = 0x21;
			board[1] = 0xF9;
			board[2] = 0x04;
			
			for(int i = 3, a = 0; a < 5; i++, a++){
				board[i] = buffer[a];
            }
			
			frame.header = [NSData dataWithBytes:board length:8];
            return [frame autorelease];
        }
		prev[0] = cur[0];
        dataBuffer = GIFGetBytes(1, dataPointer, gifData);
		[dataBuffer getBytes:cur length:1];
    }	
    [frame release];
    return nil;
}

inline static NSData *GIFReadDescriptor(NSData *gifData,int *dataPointer,AnimatedGifFrame *gifFrame,NSMutableData *gifScreen,NSMutableData *gifGlobal,int gifColorC,int gifSorted){
    
	int GIF_colorF;
    
    NSData *dataBuffer = GIFGetBytes(9, dataPointer, gifData);
    // Deep copy
	NSMutableData *GIF_screenTmp = [NSMutableData dataWithData:dataBuffer];
	
	unsigned char aBuffer[9];
	[dataBuffer getBytes:aBuffer length:9];
	
	CGRect rect;
	rect.origin.x = ((int)aBuffer[1] << 8) | aBuffer[0];
	rect.origin.y = ((int)aBuffer[3] << 8) | aBuffer[2];
	rect.size.width = ((int)aBuffer[5] << 8) | aBuffer[4];
	rect.size.height = ((int)aBuffer[7] << 8) | aBuffer[6];
    
	AnimatedGifFrame *frame = gifFrame;
	frame.area = rect;
	
	if (aBuffer[8] & 0x80) GIF_colorF = 1; else GIF_colorF = 0;
    
    unsigned char GIF_code = gifColorC, GIF_sort = gifSorted;
    
    if (GIF_colorF == 1)
        {
        GIF_code = (aBuffer[8] & 0x07);
        
        if (aBuffer[8] & 0x20){
            GIF_sort = 1;
        }else{
            GIF_sort = 0;
        }
    }

	int GIF_size = (2 << GIF_code);
	
	size_t blength = [gifScreen length];
	unsigned char bBuffer[blength];
	[gifScreen getBytes:bBuffer length:blength];
	
	bBuffer[4] = (bBuffer[4] & 0x70);
	bBuffer[4] = (bBuffer[4] | 0x80);
	bBuffer[4] = (bBuffer[4] | GIF_code);
	
	if (GIF_sort){
		bBuffer[4] |= 0x08;
    }
	
    NSMutableData *GIF_string = [NSMutableData dataWithData:[@"GIF89a" dataUsingEncoding: NSUTF8StringEncoding]];
	[gifScreen setData:[NSData dataWithBytes:bBuffer length:blength]];
    [GIF_string appendData:gifScreen];
    
	if (GIF_colorF == 1){
        dataBuffer = GIFGetBytes(3 * GIF_size, dataPointer, gifData);
		[GIF_string appendData:dataBuffer];
    }else{
		[GIF_string appendData:gifGlobal];
    }
	
	// Add Graphic Control Extension Frame (for transparancy)
	[GIF_string appendData:frame.header];
	
	char endC = 0x2c;
	[GIF_string appendBytes:&endC length:sizeof(endC)];
	
	size_t clength = [GIF_screenTmp length];
	unsigned char cBuffer[clength];
	[GIF_screenTmp getBytes:cBuffer length:clength];
	
	cBuffer[8] &= 0x40;
	
	[GIF_screenTmp setData:[NSData dataWithBytes:cBuffer length:clength]];
	
	[GIF_string appendData: GIF_screenTmp];
    dataBuffer = GIFGetBytes(1, dataPointer, gifData);
	[GIF_string appendData:dataBuffer];
	
	while (true){
        dataBuffer = GIFGetBytes(1, dataPointer, gifData);
		[GIF_string appendData:dataBuffer];
		
		unsigned char dBuffer[1];
		[dataBuffer getBytes:dBuffer length:1];
		
		long u = (long) dBuffer[0];
        
		if (u != 0x00){
            dataBuffer = GIFGetBytes(u, dataPointer, gifData);
			[GIF_string appendData:dataBuffer];
        }else{
            break;
        }
        
    }
	
	endC = 0x3b;
	[GIF_string appendBytes:&endC length:sizeof(endC)];
	
	// save the frame into the array of frames
	frame.data = GIF_string;
    return GIF_string;
}

@interface GHGifImage()
- (void)decodeGifData:(NSData *)data;
- (void)loadImageDataWithFrame:(NSArray *)frames;
@end

@implementation GHGifImage
@synthesize images = _images;
@synthesize thumbImage = _thumbImage;
@synthesize image = _image;
@synthesize animatedDelay = _animatedDelay;
- (void)dealloc{
    [_image release];
    [_thumbImage release];
    [_images release];
    [super dealloc];
}

+ (BOOL)isGifImage:(NSData*)imageData {
    const char* buf = (const char*)[imageData bytes];
	if (buf[0] == 0x47 && buf[1] == 0x49 && buf[2] == 0x46 && buf[3] == 0x38) {
		return YES;
	}
	return NO;
}

+ (GHGifImage *)gifImageWithData:(NSData *)data{
    return [[[GHGifImage alloc] initWithData:data] autorelease];
}

- (id)initWithData:(NSData *)data{
    self = [self init];
    if (self) {
        if ([GHGifImage isGifImage:data]) {
            [self decodeGifData:data];
        }else{
            _image = [[UIImage alloc] initWithData:data];
        }
    }
    return self;
}

- (UIImage*)ImageAtIndex:(int)index{
    if (index<[_images count]) {
        return [_images objectAtIndex:index];
    }
    return nil;
}

- (UIImage *)image{
    if (_image) {
        return _image;
    }
    if (_images.count>0) {
        return [_images objectAtIndex:0];
    }
    return nil;
}

- (void)decodeGifData:(NSData *)data{
    NSData *gifData = data;
    
    NSData *gifBuffer;
    NSMutableData *gifGlobal = [[NSMutableData alloc] init];
    NSMutableData *gifScreen = [[NSMutableData alloc] init];
    NSMutableArray *gifFrames = [[NSMutableArray alloc] init];
    
    int GIF_sorted;
	int GIF_colorS;
	int GIF_colorC;
	int GIF_colorF;
    // Reset file counters to 0
    int dataPointer = 0;
    
    // GIF89a, throw away
    GIFSkipBytes(6,gifData,&dataPointer);
    gifBuffer = GIFGetBytes(7,&dataPointer, gifData);
    [gifScreen setData:gifBuffer];
    // Deep copy
    
    // Copy the read bytes into a local buffer on the stack
    // For easy byte access in the following lines.
    int length = [gifBuffer length];
    unsigned char aBuffer[length];
    [gifBuffer getBytes:aBuffer length:length];
    
    if (aBuffer[4] & 0x80) GIF_colorF = 1; else GIF_colorF = 0; 
    if (aBuffer[4] & 0x08) GIF_sorted = 1; else GIF_sorted = 0;
    GIF_colorC = (aBuffer[4] & 0x07);
    GIF_colorS = 2 << GIF_colorC;
    
    if (GIF_colorF == 1){
        gifBuffer = GIFGetBytes(3*GIF_colorS, &dataPointer, gifData);
        // Deep copy
        [gifGlobal setData:gifBuffer];
    }
    
    unsigned char bBuffer[1];
    while ((gifBuffer = GIFGetBytes(1, &dataPointer, gifData))!=nil){
        AnimatedGifFrame *frame;
        
        [gifBuffer getBytes:bBuffer length:1];
        
        if (bBuffer[0] == 0x3B)
            { // This is the end
                break;
            }
        
        switch (bBuffer[0]){
            case 0x21:
            // Graphic Control Extension (#n of n)
            frame = GIFReadExtensions(gifData,&dataPointer);
            break;
            case 0x2C:
            frame = GIFReadExtensions(gifData,&dataPointer);
            // Image Descriptor (#n of n)
            GIFReadDescriptor(gifData,&dataPointer,frame,gifScreen,gifGlobal,GIF_colorC,GIF_sorted);
            break;
        }
        if (frame) {
            [gifFrames addObject:frame];   
        }
    }
    
    // clean up stuff
    
    [gifScreen release];
    
    [gifGlobal release];
    
    [self loadImageDataWithFrame:gifFrames];
    [gifFrames release];
}

- (void)loadImageDataWithFrame:(NSArray *)frames{
	// Add all subframes to the animation
	NSMutableArray *array = [[NSMutableArray alloc] init];
	for (AnimatedGifFrame *frame in frames){		
        UIImage *image = [UIImage imageWithData:frame.data];
        [array addObject:image];
    }
	
	NSMutableArray *overlayArray = [[NSMutableArray alloc] init];
	UIImage *firstImage = [array objectAtIndex:0];
	CGSize size = firstImage.size;
	CGRect rect = CGRectZero;
	rect.size = size;
	
	UIGraphicsBeginImageContext(size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	int i = 0;
	AnimatedGifFrame *lastFrame = nil;
	for (UIImage *image in array){
		// Get Frame
		AnimatedGifFrame *frame = [frames objectAtIndex:i];
		
		// Initialize Flag
		UIImage *previousCanvas = nil;
		
		// Save Context
		CGContextSaveGState(ctx);
		// Change CTM
		CGContextScaleCTM(ctx, 1.0, -1.0);
		CGContextTranslateCTM(ctx, 0.0, -size.height);
		
		// Check if lastFrame exists
		CGRect clipRect;
		
		// Disposal Method (Operations before draw frame)
		switch (frame.disposalMethod)
        {
            case 1: // Do not dispose (draw over context)
            // Create Rect (y inverted) to clipping
            clipRect = CGRectMake(frame.area.origin.x, size.height - frame.area.size.height - frame.area.origin.y, frame.area.size.width, frame.area.size.height);
            // Clip Context
            CGContextClipToRect(ctx, clipRect);
            break;
            case 2: // Restore to background the rect when the actual frame will go to be drawed
            // Create Rect (y inverted) to clipping
            clipRect = CGRectMake(frame.area.origin.x, size.height - frame.area.size.height - frame.area.origin.y, frame.area.size.width, frame.area.size.height);
            // Clip Context
            CGContextClipToRect(ctx, clipRect);
            break;
            case 3: // Restore to Previous
            // Get Canvas
            previousCanvas = UIGraphicsGetImageFromCurrentImageContext();
            
            // Create Rect (y inverted) to clipping
            clipRect = CGRectMake(frame.area.origin.x, size.height - frame.area.size.height - frame.area.origin.y, frame.area.size.width, frame.area.size.height);
            // Clip Context
            CGContextClipToRect(ctx, clipRect);
            break;
        }
		
		// Draw Actual Frame
		CGContextDrawImage(ctx, rect, image.CGImage);
		// Restore State
		CGContextRestoreGState(ctx);
		
		//delay must larger than 0, the minimum delay in firefox is 10.
		if (frame.delay <= 0) {
			frame.delay = 10;
		}
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        if (image) {
            int delay = (frame.delay+5)/10;
            if (delay<=0) {
                delay = 1;
            }
            for (int i=0; i<delay; i++) {
                [overlayArray addObject:image];   
            }
        }
		
		// Set Last Frame
		lastFrame = frame;
		
		// Disposal Method (Operations afte draw frame)
		switch (frame.disposalMethod){
            case 2: // Restore to background color the zone of the actual frame
                // Save Context
				CGContextSaveGState(ctx);
				// Change CTM
				CGContextScaleCTM(ctx, 1.0, -1.0);
				CGContextTranslateCTM(ctx, 0.0, -size.height);
				// Clear Context
				CGContextClearRect(ctx, clipRect);
				// Restore Context
				CGContextRestoreGState(ctx);
				break;
            case 3: // Restore to Previous Canvas
                // Save Context
				CGContextSaveGState(ctx);
				// Change CTM
				CGContextScaleCTM(ctx, 1.0, -1.0);
				CGContextTranslateCTM(ctx, 0.0, -size.height);
				// Clear Context
				CGContextClearRect(ctx, lastFrame.area);
				// Draw previous frame
				CGContextDrawImage(ctx, rect, previousCanvas.CGImage);
				// Restore State
				CGContextRestoreGState(ctx);
				break;
        }
		// Increment counter
		i++;
    }
	UIGraphicsEndImageContext();
	
    [_images release];
    _images = overlayArray;
	[array release];
    
    [_image release];
    if(_images.count>0) _image = [[_images objectAtIndex:0] retain];
	
	// Count up the total delay, since Cocoa doesn't do per frame delays.
	double total = 0;
	for (AnimatedGifFrame *frame in frames) {
		total += frame.delay;
	}
    _animatedDelay = total/100;
}
@end

@interface GHGIFImageView()

@end

@implementation GHGIFImageView
@synthesize gifImage = _gifImage;
- (id)initWithGIFFile:(NSString*)gifFilePath {
	NSData* imageData = [NSData dataWithContentsOfFile:gifFilePath];
	return [self initWithGIFData:imageData];
}

- (id)initWithGIFData:(NSData*)gifImageData {
	if (gifImageData.length < 4) {
		return [self init];
	}
	
	if (![GHGifImage isGifImage:gifImageData]) {
		UIImage* image = [UIImage imageWithData:gifImageData];
		return [self initWithImage:image];
	}

    GHGifImage *gifImage = [GHGifImage gifImageWithData:gifImageData];
	
	self = [self init];
	if (self) {
        [self setGifImage:gifImage];
	}
	return self;
}

- (void)setImage:(UIImage *)image{
    [self stopAnimating];
    [super setImage:image];
}
    
- (void)setGifImage:(GHGifImage *)gifImage{
    if (_gifImage == gifImage) {
        return;
    }
    [_gifImage release];
    _gifImage = [gifImage retain];
	[self setImage:gifImage.image];
    if (gifImage.images.count>1) {
        [self setAnimationImages:gifImage.images];
        [self setAnimationDuration:gifImage.animatedDelay];
        [self setAnimationRepeatCount:0];
        [self startAnimating];
    }
}

- (void)dealloc {
	[_gifImage release];
	[super dealloc];
}
@end
