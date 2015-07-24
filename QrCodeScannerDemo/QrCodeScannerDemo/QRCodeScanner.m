//
//  QRCodeScanner.m
//  QrCodeScannerDemo
//
//  Created by LiQiliang on 15/7/24.
//  Copyright (c) 2015年 LiQiliang. All rights reserved.
//

#import "QRCodeScanner.h"

@implementation QRCodeScanner
static AVCaptureSession *captureSession;
static AVCaptureVideoPreviewLayer *videoPreviewLayer;
static BOOL _isReading=NO;
UIImageView *lineImgae;
UIView *scanner;
UIView *scanView;
CGRect boundaryRect;
+(BOOL)startStopReading:(id) controller View:(UIView *) view
{
    if (_isReading) {
        [self StopReading];
        return NO;
    }else{
        return [self StartReadingWithView:view Controller:controller];
    }
}

+(BOOL)startStopReading:(id) controller View:(UIView *) view ScanFrame:(CGRect)rect{
    if (_isReading) {
        [self StopReading];
        return NO;
    }else{
        return [self StartReadingWithView:view Controller:controller];
    }
    
}

+(void)StopReading{
    [scanner removeFromSuperview];
    [scanView removeFromSuperview];
    [lineImgae removeFromSuperview];
    [captureSession stopRunning];
    captureSession=nil;
    [videoPreviewLayer removeFromSuperlayer];
    _isReading=NO;
}

+(BOOL)StartReadingWithView:(UIView *)view Controller:(id) controller{
    scanner=[[UIView alloc]initWithFrame:view.frame];
    scanner.center=view.center;
    [view addSubview:scanner];
    [self AddScanImageView:view];
    NSError *error;
    AVCaptureDevice *device=[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input=[AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"ERROR" message:@"Please allow the camera permission." delegate:controller cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return YES;
    }
    captureSession=[[AVCaptureSession alloc]init];
    [captureSession setSessionPreset:AVCaptureSessionPreset1920x1080];
    [captureSession addInput:input];
    
    AVCaptureMetadataOutput *output=[[AVCaptureMetadataOutput alloc]init];
    CGSize size = scanner.bounds.size;
    CGFloat p1 = size.height/size.width;
    CGFloat p2 = 1920./1080.;
    if (p1 < p2) {
        CGFloat fixHeight = scanner.bounds.size.width * 1920. / 1080.;
        CGFloat fixPadding = (fixHeight - size.height)/2;
        output.rectOfInterest = CGRectMake((boundaryRect.origin.y + fixPadding)/fixHeight,
                                           boundaryRect.origin.x/size.width,
                                           boundaryRect.size.height/fixHeight,
                                           boundaryRect.size.width/size.width);
    } else {
        CGFloat fixWidth = scanner.bounds.size.height * 1080. / 1920.;
        CGFloat fixPadding = (fixWidth - size.width)/2;
        output.rectOfInterest = CGRectMake(boundaryRect.origin.y/size.height,
                                           (boundaryRect.origin.x + fixPadding)/fixWidth,
                                           boundaryRect.size.height/size.height,
                                           boundaryRect.size.width/fixWidth);
    }
    [captureSession addOutput:output];
    dispatch_queue_t dispatchQueue =dispatch_queue_create("myQueue",NULL);
    [output setMetadataObjectsDelegate:controller queue:dispatchQueue];
    [output setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    videoPreviewLayer =[[AVCaptureVideoPreviewLayer alloc]initWithSession:captureSession];
    [videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [videoPreviewLayer setFrame:scanner.layer.bounds];
    [scanner.layer addSublayer:videoPreviewLayer];
    [captureSession startRunning];
    _isReading=YES;
    return YES;
}
+(void)AddScanImageView:(UIView *)view{
    scanView=[[UIView alloc]initWithFrame:view.frame];
    [[view superview] addSubview:scanView];
    
    
    //Draw the boudary
    UIGraphicsBeginImageContext(CGSizeMake(200, 200));
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(context, 0, 1, 0, 1);
    CGContextFillRect(context, CGRectMake(0  ,  0, 20, 3));
    CGContextFillRect(context, CGRectMake(0  ,  0,  3, 20));
    CGContextFillRect(context, CGRectMake(180,  0, 20, 3));
    CGContextFillRect(context, CGRectMake(197,  0,  3, 20));
    CGContextFillRect(context, CGRectMake(0  ,180,  3, 20));
    CGContextFillRect(context, CGRectMake(0  ,197, 20, 3));
    CGContextFillRect(context, CGRectMake(180,197, 20, 3));
    CGContextFillRect(context, CGRectMake(197,180,  3, 20));
    
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    CGContextFillRect(context, CGRectMake(20,0,  160, 0.2f));
    CGContextFillRect(context, CGRectMake(0,20,  0.2f, 160));
    CGContextFillRect(context, CGRectMake(199.8f,20,  0.2f, 160));
    CGContextFillRect(context, CGRectMake(20,199.8f,  160, 0.2f));
    
    CGContextStrokePath(context);
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    //Draw the scan line
    UIGraphicsBeginImageContext(CGSizeMake(190,2));
    CGContextRef lineContext=UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(lineContext, 0, 1, 0, 0.6f);
    CGColorSpaceRef colorSpaceRef=CGColorSpaceCreateDeviceRGB();
    CGColorRef whiteColor=CGColorCreate(colorSpaceRef, (CGFloat[]){1,1,1,0});
    CGColorRef greenColor=CGColorCreate(colorSpaceRef, (CGFloat[]){0,1,0,0.8});
    CFArrayRef colorArrayBefore = CFArrayCreate(kCFAllocatorDefault, (const void*[]){whiteColor, greenColor}, 2, nil);
    CGGradientRef gradientRefBefore=CGGradientCreateWithColors(colorSpaceRef, colorArrayBefore, (CGFloat[]){0.0f,1.0f});
    CFArrayRef colorArrayAfter = CFArrayCreate(kCFAllocatorDefault, (const void*[]){greenColor, whiteColor}, 2, nil);
    CGGradientRef gradientRefAfter=CGGradientCreateWithColors(colorSpaceRef, colorArrayAfter, (CGFloat[]){0.0f,1.0f});
    CGColorRelease(whiteColor);
    CGColorRelease(greenColor);
    CGContextDrawLinearGradient(lineContext, gradientRefBefore, CGPointMake(0, 0),CGPointMake(95, 0),0);
    CGContextDrawLinearGradient(lineContext, gradientRefAfter, CGPointMake(95, 0),CGPointMake(190, 0),0);
    CGColorSpaceRelease(colorSpaceRef);
    CGGradientRelease(gradientRefAfter);
    CGGradientRelease(gradientRefBefore);
    CGContextStrokePath(lineContext);
    UIImage *imageLine=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    lineImgae=[[UIImageView alloc]initWithImage:imageLine];
    
    
    UIImageView *imageView=[[UIImageView alloc]initWithImage:image];
    imageView.center=scanView.center;
    [scanView addSubview:imageView];
    boundaryRect=imageView.frame;
    
    [lineImgae setFrame:CGRectMake((scanView.frame.size.width-lineImgae.frame.size.width)/2, imageView.frame.origin.y+10, lineImgae.frame.size.width, lineImgae.frame.size.height)];
    
    
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, scanView.frame.size.width, imageView.frame.origin.y)];
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, imageView.frame.origin.y+imageView.frame.size.height, scanView.frame.size.width, (scanView.frame.size.height-imageView.frame.size.height-imageView.frame.origin.y))];
    UIView *leftView=[[UIView alloc]initWithFrame:CGRectMake(0, imageView.frame.origin.y, (scanView.frame.size.width-imageView.frame.size.width)/2, imageView.frame.size.height)];
    UIView *rightView=[[UIView alloc]initWithFrame:CGRectMake(imageView.frame.origin.x+imageView.frame.size.width, imageView.frame.origin.y, (scanView.frame.size.width-imageView.frame.size.width)/2, imageView.frame.size.height)];
    [topView setBackgroundColor:[UIColor blackColor]];
    [topView setAlpha:0.6f];
    [bottomView setBackgroundColor:[UIColor blackColor]];
    [bottomView setAlpha:0.6f];
    [leftView setBackgroundColor:[UIColor blackColor]];
    [leftView setAlpha:0.6f];
    [rightView setBackgroundColor:[UIColor blackColor]];
    [rightView setAlpha:0.6f];
    [scanView addSubview:topView];
    [scanView addSubview:bottomView];
    [scanView addSubview:leftView];
    [scanView addSubview:rightView];
    [scanView addSubview:lineImgae];
    //[lineImgae addObserver:self forKeyPath:@"layer.position" options:NSKeyValueObservingOptionNew context:nil];
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"position"];
    animation.delegate=self;
    animation.fromValue=[NSValue valueWithCGPoint:lineImgae.center];
    CGPoint toPoint=lineImgae.center;
    toPoint.y+=180;
    animation.toValue=[NSValue valueWithCGPoint:toPoint];
    [animation setDuration:1];
    [animation setAutoreverses:YES];
    [animation setRepeatCount:CGFLOAT_MAX];
    [lineImgae.layer addAnimation:animation forKey:@"scanLine"];
}
-(void)refreshTheScanLineAnimations{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self animationDidStop:nil finished:YES];
    });
    
}
@end
