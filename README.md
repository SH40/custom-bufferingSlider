# custom-bufferingSlider

## capture image
<img src="https://user-images.githubusercontent.com/43785575/157092494-0754d963-9e00-4362-8f0b-951e2c0204d3.png" width="300" height="649">

<br>

## how to use
```swift
private lazy var bufferingSlider: BufferingSlider = {
            
    let slider = BufferingSlider(frame: CGRect.zero)
    slider.addTarget(self, action: #selector(handlePlayheadSliderTouchBegin(_:)),    for: .touchDown)
    slider.addTarget(self, action: #selector(handlePlayheadSliderTouchEnd(_:)),      for: .touchUpInside)
    slider.addTarget(self, action: #selector(handlePlayheadSliderTouchEnd(_:)),      for: .touchUpOutside)
    slider.addTarget(self, action: #selector(handlePlayheadSliderValueChanged(_:)),  for: .valueChanged)
    return slider
}()
```
<br>

```swift
view.addSubview(bufferingSlider)
let margin: CGFloat = 20.0
bufferingSlider.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    bufferingSlider.widthAnchor.constraint(equalTo: view.widthAnchor, constant: margin*(-2)),
    bufferingSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    bufferingSlider.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
    bufferingSlider.heightAnchor.constraint(equalToConstant: 20),
])
bufferingSlider.isSetLayout = true
```
<br>

```swift
bufferingSlider.bufferValue = Float(value)
```