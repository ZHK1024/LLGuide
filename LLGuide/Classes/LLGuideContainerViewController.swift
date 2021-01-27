//
//  LLGuideContainerViewController.swift
//  LLGuide
//
//  Created by ZHK on 2021/1/27.
//  
//

import UIKit

class LLGuideContainerViewController: UIPageViewController {
    
    public var pageControllers: [UIViewController] = [] {
        didSet {
            guard let first = pageControllers.first else { return }
            setViewControllers([first], direction: .forward, animated: false, completion: nil)
        }
    }
    
    private lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(dismissGudie), for: .touchUpInside)
        button.setTitle("跳过", for: .normal)
        button.layer.cornerRadius = LLGuide.skipSize.height / 2
        button.backgroundColor = LLGuide.skipBackgroundColor
        button.setTitleColor(LLGuide.skipTextColor, for: .normal)
        return button
    }()
    
    /// 防止被释放
    public var holdWindow: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: UI
    
    func setupUI() {
        view.backgroundColor = .white
        dataSource = self
        
        view.addSubview(skipButton)
//        v
    }
    
    override func viewDidLayoutSubviews() {
        super.viewLayoutMarginsDidChange()
        skipButton.frame = CGRect(x: view.bounds.width - LLGuide.skipSize.width + LLGuide.skipRightOffst.x,
                                  y: view.safeAreaInsets.top + LLGuide.skipRightOffst.y,
                                  width: LLGuide.skipSize.width,
                                  height: LLGuide.skipSize.height)
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        skipButton.frame = CGRect(x: view.bounds.width - LLGuide.skipSize.width + LLGuide.skipRightOffst.x,
                                  y: view.safeAreaInsets.top + LLGuide.skipRightOffst.y,
                                  width: LLGuide.skipSize.width,
                                  height: LLGuide.skipSize.height)
    }
    
    // MARK: Action
    
    @objc func dismissGudie() {
        UIView.animate(withDuration: 1.0) {
            self.holdWindow?.alpha = 0.0
        } completion: { (_) in
            self.holdWindow?.resignKey()
            self.holdWindow = nil
        }
    }
}

extension LLGuideContainerViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pageControllers.index(of: viewController),
              index != 0, index != NSNotFound else {
            return nil
        }
        return pageControllers.element(index: index - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pageControllers.index(of: viewController),
              index != pageControllers.count - 1, index != NSNotFound else {
            return nil
        }
        return pageControllers.element(index: index + 1)
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
