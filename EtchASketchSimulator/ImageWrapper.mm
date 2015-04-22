//
//  BCCImageWrapper.m
//  EtchASketchSimulator
//
//  Created by Bri Chapman on 2/21/15.
//  Copyright (c) 2015 edu.illinois.bchapman. All rights reserved.
//
#import "Image.h"
#import "ImageWrapper.h"

@implementation ImageWrapper

@synthesize image;
@synthesize ownsImage;

+ (ImageWrapper *) imageWithCPPImage:(Image *) theImage;
{
    ImageWrapper *wrapper = [[ImageWrapper alloc] init];
    wrapper.image=theImage;
    wrapper.ownsImage=true;
    return wrapper;
}

+ (ImageWrapper *) imageWithCPPImage:(Image *) theImage ownsImage:(bool) ownsTheImage;
{
    ImageWrapper *wrapper = [[ImageWrapper alloc] init];
    wrapper.image=theImage;
    wrapper.ownsImage=ownsTheImage;
    return wrapper;
}

+ (ImageWrapper *) createImage:(UIImage *)itemImage width:(int)width height:(int)height{
    ImageWrapper *greyScale=Image::createImage(itemImage, width, height);
    return greyScale;
}

+ (ImageWrapper *) cannyEdgeExtract:(ImageWrapper*)greyScale tlow:(float) tlow thigh:(float)thigh{
    Image* greyImage = greyScale.image;
    Image* blurredImage = greyImage->gaussianBlur().image;
    ImageWrapper* canny = greyImage->cannyEdgeExtract(tlow, thigh);
    return canny;
}
+ (UIImage *) makeUIImage:(ImageWrapper*)edges{
    return edges.image->toUIImage();
}

- (void) dealloc
{
    // delete the image that we have been holding onto
    if(ownsImage) delete image;
}

@end

