<p align="center">
<img src="https://github.com/egmoll7/EMAlertController/blob/master/Images/EMAlertController.png" alt="Icon"/>
</p>

[![Language](https://img.shields.io/badge/Swift-4-orange.svg)]()
[![license](https://img.shields.io/github/license/mashape/apistatus.svg)](/LICENSE)
[![CocoaPods](https://img.shields.io/cocoapods/v/EMAlertController.svg)](http://cocoadocs.org/docsets/EMAlertController/1.0.1/)
[![GitHub stars](https://img.shields.io/github/stars/egmoll7/EMAlertController.svg)](https://github.com/egmoll7/EMAlertController/stargazers)
[![CocoaPods](https://img.shields.io/cocoapods/dt/EMAlertController.svg)]()

EMAlertController is a beautiful alternative to the stock iOS UIAlertController. This library is fully customizable with an implementation like the native UIAlertController.

<p align="center">
<img src="https://github.com/egmoll7/EMAlertController/blob/master/Images/alert.gif" alt="Icon"/>
</p>

## Table of Contents
* [Features](#features)
* [Requirements](#requirements)
* [Installation](#installation)
* [Usage](#usage)
* [Customization](#customization)
* [Icon](#icon)
* [Title](#title)
* [Title Color](#title-color)
* [Message](#message)
* [Message Color](#message-color)
* [Corner Radius](#corner-radius)
* [Background Color](#background-color)
* [Background View Color](#background-view-color)
* [Todo](#todo)
* [License](#license)

## Features
* [x] Alert Image (Optional)
* [x] Title
* [x] Scrollable Message (Optional)
* [x] Closure when a button is pressed
* [x] Fully Customizable
* [x] CocoaPods

## Requirements
* iOS 9.0+
* Xcode 9+

## Installation
[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate EMAlertController into your Xcode project using CocoaPods, specify it in your Podfile:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
pod 'EMAlertController'
end
```

Then, run the following command:

```bash
$ pod install
```

## Usage
```swift
let alert = EMAlertController(title: "EMAlertView Title", message: "This is a simple message for the EMAlertView")

let cancel = EMAlertAction(title: "CANCEL", style: .cancel)
let confirm = EMAlertAction(title: "CONFIRM", style: .normal) {
// Perform Action
}

alert.addAction(action: cancel)
alert.addAction(action: confirm)
```

## Customization

### Alert View
----------------

### Icon
```swift
let icon = UIImage(named: "imageName")

alert.iconImage = icon
```

### Title
```swift
alert.titleText = "Sample Title"
```

### Title Color
```swift
alert.titleColor = UIColor.red
// Default color = UIColor.black
```

### Message
```swift
alert.messageText = "Sample message"
```

### Message Color
```swift
alert.messageColor = UIColor.red
// Default color = UIColor.black
```

### Corner Radius
```swift
alert.cornerRadius = 10
// Default corner radius = 5
```

### Background Color
```swift
alert.backgroundColor = UIColor.white
// Default color = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
```

### Background View Color
```swift
alert.backgroundViewColor = UIColor.red
// Default color = UIColor.darkGray
```

### Background View Alpha
```swift
alert.backgroundViewAlpha = 1.0
// Default alpha = 0.2
```

### Alert Actions
----------------

### Title
```swift
action.title = "Sample Title"
```

### Title Color
```swift
action.titleColor = UIColor.red
// Normal style action default color = UIColor(red: 53/255, green: 53/255, blue: 53/255, alpha: 1.0)
// Cancel style action default color = UIColor(red: 230/255, green: 57/255, blue: 70/255, alpha: 1.0)
```

### Title Font
```swift
action.titleFont = UIFont.systemFont(ofSize: 14)
// Default font = UIFont.boldSystemFont(ofSize: 16)
```

### Background Color
```swift
action.actionBackgroundColor = UIColor.red
// Default color = UIColor.clear
```

### Button Spacing (Only when two buttons are displayed in horizontal)
```swift
alert.buttonSpacing = 0
// Default spacing = 15
```

## TODO
* [ ] Textfield Support (WIP)
* [ ] Carthage Support
* [ ] Actions Scroll Support

## License
----------------
EMAlertController is available under the MIT license. See the LICENSE file for more info.
