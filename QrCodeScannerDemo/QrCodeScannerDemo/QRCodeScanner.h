//
//  QRCodeScanner.h
//  QrCodeScannerDemo
//
//  Created by LiQiliang on 15/7/24.
//  Copyright (c) 2015年 LiQiliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface QRCodeScanner : NSObject
+(BOOL)startStopReading:(id) controller View:(UIView *) view;
+(void)StopReading;
@end
