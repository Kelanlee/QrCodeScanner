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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{

    [QRCodeScanner startStopReading:self View:self.qrcodeScanner];
}

@end
