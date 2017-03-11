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
 Show GuideView

 @param controller The Controller which to show GuideView
 */
- (void)showGuideViewOnTargetController:(UIViewController *)controller;

/**
 Create GuideView
 
 @param imageNames Guide image's name
 @return guideView
 */
+ (instancetype)guideViewWithImageNames:(NSArray <NSString *>*)imageNames;


/**
 Need show GuideView

 @return Result: YES = need, NO = no need
 */
+ (BOOL)needShowGuide;

@end
