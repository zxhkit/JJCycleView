# JJCycleView

[![CI Status](https://img.shields.io/travis/1152167469@qq.com/JJCycleView.svg?style=flat)](https://travis-ci.org/1152167469@qq.com/JJCycleView)
[![Version](https://img.shields.io/cocoapods/v/JJCycleView.svg?style=flat)](https://cocoapods.org/pods/JJCycleView)
[![License](https://img.shields.io/cocoapods/l/JJCycleView.svg?style=flat)](https://cocoapods.org/pods/JJCycleView)
[![Platform](https://img.shields.io/cocoapods/p/JJCycleView.svg?style=flat)](https://cocoapods.org/pods/JJCycleView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

JJCycleView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'JJCycleView', '~> 0.3.0'
```

## Author

xuanhe, 820331062@qq.com


## Use

```
cycleView = JJCycleView(frame: CGRect(x: 0, y: kNavBarHeight+100, width: KScreenWidth, height: 200), images: data, delegate: self, placeholderImage: nil)
cycleView.scrollDirrection = .horizontal
cycleView.imageArray = data
cycleView.isAutoScroll = true
view.addSubview(cycleView)

```


## License

JJCycleView is available under the MIT license. See the LICENSE file for more info.
