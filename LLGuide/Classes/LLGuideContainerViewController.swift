//
//  LLGuideContainerViewController.swift
//  LLGuide
//
//  Created by ZHK on 2021/1/27.
//  
//

import UIKit

class LLGuideContainerViewController: UIPageViewController {
    
    public var configuration: LLGuide.UIConfiguration?
    
    public var pageControllers: [UIViewController] = [] {
        didSet {
            guard let first = pageControllers.first else { return }
            setViewControllers([first], direction: .forward, animated: false, completion: nil)
        }
    }
    
    /// 跳过按钮
    private lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(dismissGudie), for: .touchUpInside)
        button.setTitle("跳过", for: .normal)
        button.layer.cornerRadius = LLGuide.skipSize.height / 2
        button.backgroundColor = LLGuide.skipBackgroundColor
        button.setTitleColor(LLGuide.skipTextColor, for: .normal)
        button.addTarget(self, action: #selector(dismissGudie), for: .touchUpInside)
        return button
    }()
    
    /// 进入按钮
    private lazy var enterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("立即进入", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.frame = CGRect(x: 0.0, y: 0.0, width: 200.0, height: 50.0)
        button.isHidden = true
        return button
    }()
    
    /// UIPageControl
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pageControllers.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPageIndicatorTintColor = .systemBlue
        if #available(iOS 14, *) {
            pageControl.backgroundStyle = .minimal
        }
        pageControl.addTarget(self, action: #selector(pageControlDidChanged(control:)), for: .valueChanged)
        return pageControl
    }()
    
    /// 引用 UIWindow 防止出了作用域被释放
    /// 在需要释放的时候只需要把 windowHolder 置为 nil 即可
    public var windowHolder: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: UI
    
    func setupUI() {
        view.backgroundColor = .white
        dataSource = self
        delegate   = self
        view.addSubview(skipButton)
        
        if LLGuide.isPageControlHidden == false {
            view.addSubview(pageControl)
        }
        
        if LLGuide.isEnterButtonHidden == false {
            view.addSubview(enterButton)
        }
        
        configuration?(skipButton,
                       LLGuide.isEnterButtonHidden ? nil : enterButton,
                       LLGuide.isPageControlHidden ? nil : pageControl)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        /// skipButton 
        skipButton.frame = CGRect(x: view.bounds.width - LLGuide.skipSize.width + LLGuide.skipRightOffset.x,
                                  y: view.safeAreaInsets.top + LLGuide.skipRightOffset.y,
                                  width: LLGuide.skipSize.width,
                                  height: LLGuide.skipSize.height)
        
        if LLGuide.isPageControlHidden == false {
            pageControl.frame = CGRect(x: 0.0, y: 0.0, width: view.bounds.width * 0.8, height: 30)
            pageControl.center = CGPoint(x: view.bounds.midX + LLGuide.pageControlOffset.x,
                                         y: view.bounds.midY + LLGuide.pageControlOffset.y)
        }
        
        if LLGuide.isEnterButtonHidden == false {
            enterButton.center = CGPoint(x: view.bounds.midX + LLGuide.enterButtonOffset.x,
                                         y: view.bounds.midY + LLGuide.enterButtonOffset.y)
        }
    }
    
    // MARK: Action
    
    @objc func dismissGudie() {
        UIView.animate(withDuration: 1.0) {
            self.windowHolder?.alpha = 0.0
        } completion: { (_) in
            self.windowHolder?.resignKey()
            self.windowHolder = nil
        }
    }
    
    /// UIPageControl 时间响应
    /// - Parameter control: UIPageControl 对象
    @objc func pageControlDidChanged(control: UIPageControl) {
        let index = control.currentPage
        guard let current = pageControllers.firstIndex(where: { $0 == viewControllers?.first }),
              current != index,
              index < pageControllers.count else {
            return
        }
        let direction: UIPageViewController.NavigationDirection = index < current ? .reverse : .forward
        setViewControllers([pageControllers[index]], direction: direction, animated: true, completion: nil)
    }
}

extension LLGuideContainerViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pageControllers.firstIndex(of: viewController),
              index != 0, index != NSNotFound else {
            return nil
        }
        return pageControllers.element(index: index - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pageControllers.firstIndex(of: viewController),
              index != pageControllers.count - 1, index != NSNotFound else {
            return nil
        }
        return pageControllers.element(index: index + 1)
    }
}

extension LLGuideContainerViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        /// 将要进入的页面不是最后一页, 直接隐藏按钮
        guard LLGuide.isEnterButtonHidden == false,
              pageControllers.last != pendingViewControllers.first else {
            return
        }
        enterButton.isHidden = true
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let current = viewControllers?.first,
              let index = pageControllers.firstIndex(where: { $0 == current }) else {
            return
        }
        pageControl.currentPage = index
        if LLGuide.isEnterButtonHidden == false {
            /// 最后一页显示
            enterButton.isHidden = !(index == pageControllers.count - 1)
        }
    }
}

fileprivate extension Array {
    
    func element(index: Int) -> Element? {
        if index < 0 || index >= count {
            return nil
        }
        return self[index]
    }
}
