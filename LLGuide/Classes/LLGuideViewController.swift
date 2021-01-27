//
//  LLGuideViewController.swift
//  LLGuide
//
//  Created by ZHK on 2021/1/27.
//  
//

import UIKit

class LLGuideViewController: UIViewController {
    
    private let imageView = UIImageView()
    
    init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        imageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        imageView.contentMode = LLGuide.contentModel
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = view.bounds
    }

    
}
