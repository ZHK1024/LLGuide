//
//  ZHKGuideView.h
//  GuideView
//
//  Created by ZHK on 2017/3/11.
//  Copyright © 2017年 Weiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHKGuideView : UIView

/**
 显示 GuideView
 
 @param controller GuideView 的载体 ViewController
 */
- (void)showGuideViewOnTargetController:(UIViewController *)controller;

/**
 创建引导图
 
 @param imageNames 引导图图片名称
 @return guideView
 */
+ (instancetype)guideViewWithImageNames:(NSArray <NSString *>*)imageNames;


/**
 是否需要显示引导图
 
 @return YES = 需要, NO = 不需要
 */
+ (BOOL)needShowGuide;

@end
