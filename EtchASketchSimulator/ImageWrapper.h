//
//  BCCImageWrapper.h
//  EtchASketchSimulator
//
//  Created by Bri Chapman on 2/21/15.
//  Copyright (c) 2015 edu.illinois.bchapman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>

#if defined __cplusplus
class Image;    // forward class declaration
#else
typedef struct Image Image;   // forward struct declaration
#endif
// objective C wrapper for our image class
@interface ImageWrapper : NSObject {
    Image *image;
    bool ownsImage;
}

@property(assign, nonatomic) Image *image;
@property(assign, nonatomic) bool ownsImage;
+ (ImageWrapper *) imageWithCPPImage:(Image *) theImage;
+ (ImageWrapper *) createImage:(UIImage *)itemImage width:(int)width height:(int)height;
+ (ImageWrapper *) cannyEdgeExtract:(ImageWrapper*)greyScale tlow:(float) tlow thigh:(float)thigh;
+ (UIImage *) makeUIImage:(ImageWrapper*)edges;
@end


