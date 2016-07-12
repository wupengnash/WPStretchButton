//
//  ViewController.m
//  WPStretchButton
//
//  Created by wupeng on 16/7/7.
//  Copyright © 2016年 wupeng. All rights reserved.
//

#import "ViewController.h"
#import "WPStretchButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WPStretchButton *button = [[WPStretchButton alloc] initWithFrame:CGRectMake(50, 50, 60, 60)];
    [self.view addSubview:button];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
