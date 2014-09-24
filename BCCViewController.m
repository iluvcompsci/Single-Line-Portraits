//
//  BCCViewController.m
//  EtchASketchSimulator
//
//  Created by Bri Chapman on 9/15/14.
//  Copyright (c) 2014 edu.illinois.bchapman. All rights reserved.
//

#import "BCCViewController.h"


@interface BCCViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation BCCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    FILE *fp;
	int w, h, i;
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"lena"
                                                         ofType:@"pgm"];
    
	if ((fp = fopen([filePath UTF8String], "r")) == NULL) {
		printf("ERROR: can't open %s!", [filePath UTF8String]);
	} else {
		if (read_pgm_hdr(fp, &w, &h) != -1) {
			struct image img, img_gauss, img_out; //img_scratch, img_scratch2,
			printf("*** PGM file recognized, reading data into image struct ***\n");
			img.width = w;
			img.height = h;
			unsigned char *img_data = malloc(w * h * sizeof(char));
			for (i = 0; i < w * h; i++) {
				img_data[i] = fgetc(fp);
			}
			img.pixel_data = img_data;
			img_out.width = img_gauss.width = w;
			img_out.height = img_gauss.height = h;
			unsigned char *img_gauss_data = malloc(w * h * sizeof(char));
			img_gauss.pixel_data = img_gauss_data;
			unsigned char *img_out_data = malloc(w * h * sizeof(char));
			img_out.pixel_data = img_out_data;
			printf("*** image struct initialized ***\n");
			printf("*** performing gaussian noise reduction ***\n");
			gaussian_noise_reduce(&img, &img_gauss);
			//printf("*** performing morphological closing ***\n");
			//morph_close(&img, &img_scratch, &img_scratch2, &img_gauss);
			canny_edge_detect(&img_gauss, &img_out);
			//write_pgm_image(&img_out);
            
            ////////////////// end read file /////////////
            
            CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceGray();
            CFDataRef rgbData = CFDataCreate(NULL, img_out.pixel_data, w * h);
            CGDataProviderRef provider = CGDataProviderCreateWithCFData(rgbData);
            CGImageRef rgbImageRef = CGImageCreate(w, h, 8, 8, w , colorspace, kCGBitmapByteOrderDefault, provider, NULL, true, kCGRenderingIntentDefault);
            CFRelease(rgbData);
            CGDataProviderRelease(provider);
            CGColorSpaceRelease(colorspace);
            UIImage * newimage = [UIImage imageWithCGImage:rgbImageRef];
            self.imageView.frame = CGRectMake(self.imageView.frame.origin.x,self.imageView.frame.origin.y, w, h);
            [self.imageView setImage:newimage];
            CGImageRelease(rgbImageRef);
            
            //self.imageView.image = [UIImage imageWithData:img_out.pixel_data];
            
			free(img_data);
			free(img_gauss_data);
			free(img_out_data);
		} else {
			printf("ERROR: %s is not a PGM file!", [filePath UTF8String]);
		}
	}
	//return(1);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
