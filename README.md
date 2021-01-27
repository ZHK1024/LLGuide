# LLGuide

[![CI Status](https://img.shields.io/travis/Ruris/LLGuide.svg?style=flat)](https://travis-ci.org/Ruris/LLGuide)
[![Version](https://img.shields.io/cocoapods/v/LLGuide.svg?style=flat)](https://cocoapods.org/pods/LLGuide)
[![License](https://img.shields.io/cocoapods/l/LLGuide.svg?style=flat)](https://cocoapods.org/pods/LLGuide)
[![Platform](https://img.shields.io/cocoapods/p/LLGuide.svg?style=flat)](https://cocoapods.org/pods/LLGuide)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

To install it, simply add the following line to your Podfile:

```ruby
pod 'LLGuide', :git => 'https://github.com/ZHK1024/LLGuide.git'

pod 'LLGuide', :git => 'https://github.com/ZHK1024/LLGuide.git', :tag => s.version.to_s
```

## Usage

```swift
/// UIImage
LLGuide.config(version: "3") { () -> [UIImage] in
    ["guide_image_01",
     "guide_image_02",
     "guide_image_03",
     "guide_image_04"
    ].compactMap {
        UIImage(named: $0)
    }
}

/// UIViewController
LLGuide.config(version: "1") { () -> [UIViewController] in
    [UIColor.systemRed,
     UIColor.systemGreen,
     UIColor.systemBlue,
     UIColor.systemTeal
    ].map {
        GuideViewController(backgroundColor: $0)
    }
}
```

## Author

ZHK1024, ZHK1024@qq.com

## License

LLGuide is available under the MIT license. See the LICENSE file for more info.
