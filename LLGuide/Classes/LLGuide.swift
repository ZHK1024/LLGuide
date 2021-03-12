//
//  AppDelegate.swift
//  LLGuide
//
//  Created by ZHK on 01/27/2021.
//  Copyright (c) 2021 ZHK. All rights reserved.
//

import UIKit

open class LLGuide {
    
    /// (SkipButton, EnterButton, PageControl)
    public typealias UIConfiguration = (UIButton?, UIButton?, UIPageControl?) -> Void
    
    // MARK: 跳过按钮
    
    /// 跳过按钮文本颜色
    public static var skipTextColor: UIColor = .systemBlue
    
    /// 跳过按钮背景颜色
    public static var skipBackgroundColor: UIColor = .white
    
    /// 跳过按钮 size
    public static var skipSize = CGSize(width: 75.0, height: 30.0)
    
    /// 跳过按钮右上对齐便宜量
    public static var skipRightOffset = CGPoint(x: -20.0, y: 10.0)
    
    // MARK: 进入按钮
    
    /// 是否隐藏进入按钮
    public static var isEnterButtonHidden: Bool = false
    
    /// 进入按钮偏移量 (0 偏移为屏幕中心)
    public static var enterButtonOffset = CGPoint(x: 0.0, y: 260.0)
    
    // MARK: UIPageControl
    
    /// 是否隐藏 UIPageControl
    public static var isPageControlHidden: Bool = false
    
    /// UIPageControl 布局偏移量 (0 偏移为屏幕中心)
    public static var pageControlOffset = CGPoint(x: 0.0, y: 350.0)
    
    // MARK: 图片
    
    /// 图片 UIImageView 图片缩放模式 (仅仅使用 UIImage 时候生效)
    public static var contentModel: UIView.ContentMode = .scaleAspectFill
    
    /// 图片边距
    public static var contentInsets: UIEdgeInsets = .zero
    
    /// 版本字段 key
    private static let kVersionKey = "6E13295654476C83"
    
    /// 通过 UIImage 数组配置 Guide 视图内容
    /// - Parameters:
    ///   - version:     当前版本号 (不传表示每次启动都显示, version 变化后仅在每次更新版本后第一次启动时展示)
    ///   - windowLevel: Window 展示优先级, 默认为 10
    ///   - images:      UIImage 对象数组
    ///   - configuration: UI 配置
    public static func guide(version: String? = nil,
                              windowLevel: UIWindow.Level = .alert,
                              images: () -> [UIImage],
                              configuration: UIConfiguration? = nil) {
        guard shouldDisplay(version: version) else { return }
        let controllers = images().map { LLGuideViewController(image: $0) }
        guard controllers.count > 0 else { return }
        window(windowLevel: windowLevel, controllers: controllers, configuration: configuration).makeKeyAndVisible()
    }
    
    /// 通过 UIController 数组配置 Guide 视图内容
    /// - Parameters:
    ///   - version:     当前版本号 (不传表示每次启动都显示, version 变化后仅在每次更新版本后第一次启动时展示)
    ///   - windowLevel: Window 展示优先级, 默认为 10
    ///   - controllers: 控制器数组
    ///   - configuration: UI 配置
    public static func guide(version: String? = nil,
                              windowLevel: UIWindow.Level = .alert,
                              controllers: () -> [UIViewController],
                              configuration: UIConfiguration? = nil) {
        guard shouldDisplay(version: version) else { return }
        let vcs = controllers()
        guard vcs.count > 0 else { return }
        window(windowLevel: windowLevel, controllers: vcs, configuration: configuration).makeKeyAndVisible()
    }
    
    ///  创建 Guide 视图 Window 对象
    /// - Parameters:
    ///   - windowLevel: Window 展示优先级
    ///   - controllers: 控制器列表
    ///   - configuration: UI 配置
    /// - Returns: UIWindow 对象
    static private func window(windowLevel: UIWindow.Level,
                               controllers: [UIViewController],
                               configuration: UIConfiguration?) -> UIWindow {
        let containerViewController = LLGuideContainerViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [:])
        containerViewController.pageControllers = controllers
        containerViewController.configuration = configuration
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.windowLevel = windowLevel
        window.rootViewController = containerViewController
        window.isOpaque = false
        /// 互相强引用, 防止 window 被释放
        /// 释放在 containerViewController 内部进行
        containerViewController.windowHolder = window
        return window
    }
    
    /// 根据版本判断是否需要显示
    /// - Parameter version: 版本号
    /// - Returns: 判断结果
    static private func shouldDisplay(version: String?) -> Bool {
        if version == nil { return true }
        let result = UserDefaults.standard.value(forKey: kVersionKey) as? String != version
        UserDefaults.standard.setValue(version, forKey: kVersionKey)
        UserDefaults.standard.synchronize()
        return result
    }
}
