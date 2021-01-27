//
//  AppDelegate.swift
//  LLGuide
//
//  Created by ZHK on 01/27/2021.
//  Copyright (c) 2021 ZHK. All rights reserved.
//

import Foundation

open class LLGuide {
    
    /// 跳过按钮文本颜色
    public static var skipTextColor: UIColor = .systemBlue
    
    /// 跳过按钮背景颜色
    public static var skipBackgroundColor: UIColor = .white
    
    /// 跳过按钮 size
    public static var skipSize = CGSize(width: 75.0, height: 30.0)
    
    /// 跳过按钮右上对齐便宜量
    public static var skipRightOffst = CGPoint(x: -20.0, y: 10.0)
    
    /// 图片 UIImageView 图片缩放模式 (仅仅使用 UIImage 时候生效)
    public static var contentModel: UIViewContentMode = .scaleAspectFill
    
    /// 版本字段 key
    private static let kVersionKey = "6E13295654476C83"
    
    /// 通过 UIImage 数组配置 Guide 视图内容
    /// - Parameters:
    ///   - version:     当前版本号 (不传表示每次启动都显示, version 变化后仅在每次更新版本后第一次启动时展示)
    ///   - windowLevel: Window 展示优先级, 默认为 10
    ///   - images:      UIImage 对象数组
    public static func config(version: String? = nil, windowLevel: Int = 10, images: () -> [UIImage]) {
        guard shouldDisplay(version: version) else { return }
        let controllers = images().map { LLGuideViewController(image: $0) }
        guard controllers.count > 0 else { return }
        windiw(windowLevel: windowLevel, controllers: controllers).makeKeyAndVisible()
    }
    
    /// 通过 UIController 数组配置 Guide 视图内容
    /// - Parameters:
    ///   - version:     当前版本号 (不传表示每次启动都显示, version 变化后仅在每次更新版本后第一次启动时展示)
    ///   - windowLevel: Window 展示优先级, 默认为 10
    ///   - controllers: 控制器数组
    public static func config(version: String? = nil, windowLevel: Int = 10, controllers: () -> [UIViewController]) {
        guard shouldDisplay(version: version) else { return }
        let vcs = controllers()
        guard vcs.count > 0 else { return }
        windiw(windowLevel: windowLevel, controllers: vcs).makeKeyAndVisible()
    }
    
    ///  创建 Guide 视图 Window 对象
    /// - Parameters:
    ///   - windowLevel: Window 展示优先级
    ///   - controllers: 控制器列表
    /// - Returns: UIWindow 对象
    static private func windiw(windowLevel: Int, controllers: [UIViewController]) -> UIWindow {
        let containerViewController = LLGuideContainerViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [:])
        containerViewController.pageControllers = controllers
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.windowLevel = UIWindowLevel(windowLevel)
        window.rootViewController = containerViewController
        window.isOpaque = false
        /// 互相强引用, 方式 window 被释放
        /// 释放在 containerViewController 内部进行
        containerViewController.holdWindow = window
        return window
    }
    
    /// 根据版本判断是否需要显示
    /// - Parameter version: 版本号
    /// - Returns: 判断结果
    static private func shouldDisplay(version: String?) -> Bool {
        if version == nil {
            return true
        }
        guard let oldVersion = UserDefaults.standard.value(forKey: kVersionKey) as? String else {
            return true
        }
        return oldVersion != version
    }
}
