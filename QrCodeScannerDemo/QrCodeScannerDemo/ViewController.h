//
//  ViewController.h
//  QrCodeScannerDemo
//
//  Created by LiQiliang on 15/7/24.
//  Copyright (c) 2015年 LiQiliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRCodeScanner.h"
@interface ViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic,strong) IBOutlet UIView *qrcodeScanner;

@end

