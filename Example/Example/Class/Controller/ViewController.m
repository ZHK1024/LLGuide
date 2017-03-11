//
//  ViewController.m
//  Example
//
//  Created by ZHK on 2017/3/11.
//  Copyright © 2017年 Weiyu. All rights reserved.
//

#import "ViewController.h"
#import "ZHKGuideView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([ZHKGuideView needShowGuide]) {
        ZHKGuideView *guideView = [ZHKGuideView guideViewWithImageNames:@[@"guide_image_01", @"guide_image_02", @"guide_image_03", @"guide_image_04"]];
        [guideView showGuideViewOnTargetController:self.navigationController];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
