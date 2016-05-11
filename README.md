# TVKit
UI components for tvOS.

NOTE: This repository is work in progress.

## Features
- Highly customizable
- Supports @IBDesignable to live-render the component in the Interface Builder
- By supporting @IBInspectable, the class properties can be exposed in the Interface Builder, and you can edit these properties in realtime

- Components:
  - Slider: Inspired `UISlider`

## Installation
### CocoaPods

```Podfile
pod 'TVKit'
```

### Carthage
// Coming soon

### Swift Package Manager
// Coming soon

## Components
### Slider
![slider](https://github.com/jinSasaki/TVKit/raw/master/Assets/slider.gif)

```swift
class ViewController: UIViewController {
  @IBOutlet private weak var slider: Slider!

  override func viewDidLoad() {
      super.viewDidLoad()

      // Customize value, max and min (you can also customize in InterfaceBuilder).
      slider.min = 0.0
      slider.max = 1000
      slider.value = 100

      // Customize visual with label, imageView and so on.
      slider.leftImageView.image = UIImage(named: "rewind")
      slider.rightImageView.image = UIImage(named: "skip")
      slider.leftLabel.hidden = true
      slider.rightLabel.textColor = UIColor.redColor()
  }
}
```

Implement `SliderDelegate` if you want to receive event from Slider.

```swift
// slider.delegate = self
extension ViewController: SliderDelegate {
  func slider(slider: Slider, textWithValue value: Double) -> String {
      // Customize text on the seeker view with value.
      return "\(Int(value))"
  }

  func sliderDidTap(slider: Slider) {
    // Do something
  }

  func slider(slider: Slider, didChangeValue value: Double) {
    // Do something
  }
}
```

## Requirements

- tvOS 9.2+
- Xcode 7

## TODO
- Components
  - Stepper
  - Switch
  - FocusableLabel

- Installation
  - Carthage
  - Swift Package Manager

## License
TVKit is released under the MIT license. See LICENSE for details.
