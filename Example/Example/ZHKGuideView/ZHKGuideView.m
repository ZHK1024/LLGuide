//
//  ZHKGuideView.m
//  GuideView
//
//  Created by ZHK on 2017/3/11.
//  Copyright © 2017年 Weiyu. All rights reserved.
//

#import "ZHKGuideView.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

#define VERSION_KEY @"APP_VERSION"
#define PAGECONTROL_MARGIN_BOTTOM 60.0

@interface ZHKGuideView () <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray       *imageNames;
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation ZHKGuideView

+ (BOOL)needShowGuide {
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:VERSION_KEY];
    NSString *bundleVsesion = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleShortVersionString"];
    if ([version isEqualToString:bundleVsesion]) {
        return NO;
    }
    [[NSUserDefaults standardUserDefaults] setValue:bundleVsesion forKey:VERSION_KEY];
    return YES;
}

+ (instancetype)guideViewWithImageNames:(NSArray <NSString *>*)imageNames {
    return [[ZHKGuideView alloc] initWithImageNames:imageNames];
}

#pragma mark - Init

- (instancetype)initWithImageNames:(NSArray <NSString *>*)imageNames {
    if (self = [super initWithFrame:SCREEN_BOUNDS]) {
        self.imageNames = imageNames;
        
        [self buildContent];
    }
    return self;
}

#pragma mark -

- (void)showGuideViewOnTargetController:(UIViewController *)controller {
    [controller.view addSubview:self];
}

/**
 创建引导内容
 */
- (void)buildContent {
    if (_imageNames.count == 0) {
        [self removeFromSuperview];
        return;
    }
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.scrollView];
    
    for (NSInteger i = 0; i < _imageNames.count; ++i) {
        UIImageView *imageView = [self imageViewWithImageName:_imageNames[i] index:i];
        [_scrollView addSubview:imageView];
    }
    
    [self addSubview:self.pageControl];
}

/**
 创建 imageView

 @param imageName  引导图图片名字
 @param index 引导图索引
 @return  imageView
 */
- (UIImageView *)imageViewWithImageName:(NSString *)imageName index:(NSInteger)index {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(index * SCREEN_SIZE.width, 0, SCREEN_SIZE.width, SCREEN_SIZE.height);
    return imageView;
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = (NSInteger)(scrollView.contentOffset.x / SCREEN_SIZE.width);
    _pageControl.currentPage = index;
}

#pragma mark - UIPageControl Action

- (void)pageControlAction:(UIPageControl *)ctl {
    [_scrollView setContentOffset:CGPointMake(ctl.currentPage * SCREEN_SIZE.width, 0) animated:YES];
}

#pragma mark - Getter

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(SCREEN_SIZE.width * _imageNames.count, 0);
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 20.0)];
        _pageControl.numberOfPages = _imageNames.count;
        _pageControl.center = CGPointMake(SCREEN_SIZE.width / 2, SCREEN_SIZE.height - PAGECONTROL_MARGIN_BOTTOM);
        [_pageControl addTarget:self action:@selector(pageControlAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

@end
