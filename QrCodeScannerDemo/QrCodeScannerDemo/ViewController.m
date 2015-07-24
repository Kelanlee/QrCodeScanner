//
//  ViewController.m
//  QrCodeScannerDemo
//
//  Created by LiQiliang on 15/7/24.
//  Copyright (c) 2015年 LiQiliang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
bool isReading=false;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{

    isReading=[QRCodeScanner startStopReading:self View:self.qrcodeScanner];
}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects!=nil&&[metadataObjects count]>0) {
        AVMetadataMachineReadableCodeObject *metadataObj=[metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode])
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (isReading) {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"QR Message" message:[metadataObj stringValue] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                    [alert show];
                    isReading=[QRCodeScanner startStopReading:self View:self.qrcodeScanner];
                    
                }
                
            });
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    isReading=[QRCodeScanner startStopReading:self View:self.qrcodeScanner];
}

@end
