import Foundation
import UIKit

class ViewController: UIViewController {

    private lazy var bufferingSlider: BufferingSlider = {
            
        let slider = BufferingSlider(frame: CGRect.zero)
        slider.addTarget(self, action: #selector(handlePlayheadSliderTouchBegin(_:)),    for: .touchDown)
        slider.addTarget(self, action: #selector(handlePlayheadSliderTouchEnd(_:)),      for: .touchUpInside)
        slider.addTarget(self, action: #selector(handlePlayheadSliderTouchEnd(_:)),      for: .touchUpOutside)
        slider.addTarget(self, action: #selector(handlePlayheadSliderValueChanged(_:)),  for: .valueChanged)
        return slider
    }()
    
    private lazy var slider: UISlider = {
            
        let slider = UISlider()
        slider.tintColor = UIColor.red
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.minimumTrackTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        slider.maximumTrackTintColor = #colorLiteral(red: 0.3321716189, green: 0.3321716189, blue: 0.3321716189, alpha: 1)
        slider.addTarget(self, action: #selector(handlePlayheadSliderValueChanged2(_:)), for: .valueChanged)
        return slider
    }()
    
    private lazy var slider2: UISlider = {
            
        let slider = UISlider()
        slider.tintColor = UIColor.red
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.minimumTrackTintColor =  #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        slider.maximumTrackTintColor =  #colorLiteral(red: 0.3321716189, green: 0.3321716189, blue: 0.3321716189, alpha: 1)
        slider.addTarget(self, action: #selector(handlePlayheadSliderValueChanged3(_:)), for: .valueChanged)
        return slider
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black

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
        
        //TEST1
        view.addSubview(slider)
        slider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            slider.widthAnchor.constraint(equalTo: view.widthAnchor, constant: margin*(-2)),
            slider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            slider.topAnchor.constraint(equalTo: bufferingSlider.bottomAnchor, constant: 40),
            slider.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        //TEST2
        view.addSubview(slider2)
        slider2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            slider2.widthAnchor.constraint(equalTo: view.widthAnchor, constant: margin*(-2)),
            slider2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            slider2.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 40),
            slider2.heightAnchor.constraint(equalToConstant: 20),
        ])
        
    }
    
    @objc private func handlePlayheadSliderTouchBegin(_ sender: BufferingSlider){
        print("handlePlayheadSliderTouchBegin: (\(sender.value) \(sender.bufferValue))")
    }
    @objc private func handlePlayheadSliderTouchEnd(_ sender: BufferingSlider){
        print("handlePlayheadSliderTouchEnd: (\(sender.value) \(sender.bufferValue))")
    }
    @objc private func handlePlayheadSliderValueChanged(_ sender: BufferingSlider){
        print("handlePlayheadSliderValueChanged: (\(sender.value) \(sender.bufferValue))")
    }

    
    //TEST1
    @objc private func handlePlayheadSliderValueChanged2(_ sender: UISlider){
        print("TEST1 sender.value = \(sender.value)")
        bufferingSlider.value = Float(sender.value)
    }
    
    //TEST2
    @objc private func handlePlayheadSliderValueChanged3(_ sender: UISlider){
        print("TEST2 sender.value = \(sender.value)")
        bufferingSlider.bufferValue = Float(sender.value)
    }

}
