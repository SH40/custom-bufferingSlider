import Foundation
import UIKit

class BufferingSlider: UIControl {
    
    public var isSingleTouch: Bool = true
    public var isRepeatMode: Bool = false {
        didSet{
            if isRepeatMode {
                repeatStartValue = value
                trackHighlightTintColor  = UIColor.clear
            }else{
                repeatStartValue = 0
                trackHighlightTintColor  = trackHighlightTintColorOrigin
            }
        }
    }
    
    var minimumValue: Float = 0.0 {
        didSet {
            updateLayerFrames()
        }
    }
    var maximumValue: Float = 1.0 {
        didSet {
            updateLayerFrames()
        }
    }
    var value: Float = 0.0 {
        didSet {
            updateLayerFrames()
        }
    }
    var bufferValue: Float = 0.0 {
        didSet {
            updateLayerFrames()
        }
    }
    var repeatStartValue: Float = 0.0 {
        didSet {
            updateLayerFrames()
        }
    }
    var thumbWidth: CGFloat {
        return CGFloat(12)
    }
    var trackTintColor: UIColor = #colorLiteral(red: 0.262745098, green: 0.262745098, blue: 0.262745098, alpha: 1) {
        didSet {
            trackLayerBuffer.setNeedsDisplay()
        }
    }
    let trackHighlightTintColorOrigin = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
    var trackHighlightTintColor: UIColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1) {
        didSet {
            trackLayerBuffer.setNeedsDisplay()
        }
    }
    let trackHighlightTintColorPOrigin = UIColor(white: 1.0, alpha: 1.0)
    var trackHighlightTintColorP: UIColor = UIColor(white: 1.0, alpha: 1.0) {
        didSet {
            trackLayerBuffer.setNeedsDisplay()
        }
    }
    var thumbTintColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) {
        didSet {
            lowerThumbLayer.setNeedsDisplay()
        }
    }
    var curvaceousness: CGFloat = 1.0 {
        didSet {
            trackLayerBuffer.setNeedsDisplay()
            lowerThumbLayer.setNeedsDisplay()
        }
    }
    
    var heightScale: CGFloat = 1.0
    let lowerThumbLayer  = BufferingSliderThumbLayer()
    let trackLayerBuffer = BufferingSliderTrackLayer()
    
    required init(coder: NSCoder) { super.init(coder: coder)! }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds       = true
        self.layer.masksToBounds = true
        
        trackLayerBuffer.rangeSlider = self
        lowerThumbLayer.rangeSlider  = self

        trackLayerBuffer.contentsScale = UIScreen.main.scale
        
        layer.addSublayer(trackLayerBuffer)
        layer.addSublayer(lowerThumbLayer)
        
        updateLayerFrames()
    }
    
    func updateLayerFrames() {
        CATransaction.setDisableActions(true)
        trackLayerBuffer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height / 2.4)
        trackLayerBuffer.setNeedsDisplay()
        
        let lowerThumbCenter = CGFloat(positionForValue(value: value, isThum: true))
        lowerThumbLayer.frame = CGRect(x: lowerThumbCenter - thumbWidth / 2.0, y: bounds.height/2 - thumbWidth/2, width: thumbWidth, height: thumbWidth)
        lowerThumbLayer.setNeedsDisplay()
    }

    func positionForValue(value: Float, isThum: Bool = false, isRepeat: Bool = false) -> Float {
        
        if isRepeat {
            return Float(bounds.width) * (value - minimumValue ) / (maximumValue - minimumValue)
        }
        
        if isThum {
            // 1 => bounds.width - thumbWidth / 2
            // 0 => thumbWidth / 2.0
            return Float(bounds.width - thumbWidth ) * (value - minimumValue ) / (maximumValue - minimumValue) + Float(thumbWidth / 2.0)
            
        }else{
            // 1 => bounds.width
            // 0 => thumbWidth / 2
            return Float(bounds.width - thumbWidth / 2.0 ) * (value - minimumValue ) / (maximumValue - minimumValue) + Float(thumbWidth / 2.0)
        }
    }
    
    override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    // * auto layout에서 사용
    var isSetLayout: Bool = false {
        didSet{
            if isSetLayout{
                self.layoutIfNeeded()
                updateLayerFrames()
            }
        }
    }
    
    // 5. touch event
    var previousLocation = CGPoint()
    
    //
    // 첫 터치 이벤트
    //
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousLocation = touch.location(in: self)
        
        // Hit test the thumb layers
        let size = CGSize(width: lowerThumbLayer.frame.size.width * 1.7, height: lowerThumbLayer.frame.size.height * 1.7 )
        let rect = CGRect(origin: lowerThumbLayer.frame.origin, size: size)
        
        if rect.contains(previousLocation) {
            lowerThumbLayer.highlighted = true

        }else{
            
            if isSingleTouch {
                let deltaLocation = Float(previousLocation.x) - Float(thumbWidth / 2)
                let deltaValue = (maximumValue - minimumValue) * deltaLocation / Float(bounds.width - thumbWidth)
                value = deltaValue
                value = boundValue(value: value, toLowerValue: minimumValue, upperValue: maximumValue)
                
                setNeedsDisplay()
            }
        }
        
        if isSingleTouch {
            return true
        }else{
            return lowerThumbLayer.highlighted
        }
        
    }

    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)

        // 1. Determine by how much the user has dragged
        let deltaLocation = Float(location.x - previousLocation.x)
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / Float(bounds.width - thumbWidth)
        
        previousLocation = location
        
        // 2. Update the values
        if lowerThumbLayer.highlighted {
            value += deltaValue
            value = boundValue(value: value, toLowerValue: minimumValue, upperValue: maximumValue)
        }else{
            
            if isSingleTouch {
                value += deltaValue
                value = boundValue(value: value, toLowerValue: minimumValue, upperValue: maximumValue)
            }
        }
        
        sendActions(for: .valueChanged)
        
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowerThumbLayer.highlighted = false
    }
    
    func boundValue(value: Float, toLowerValue: Float, upperValue: Float) -> Float {
        return min(max(value, toLowerValue), upperValue)
    }
    
}


class BufferingSliderThumbLayer: CALayer {
    
    var highlighted = false {
        didSet{
            setNeedsDisplay()
        }
    }
    
    weak var rangeSlider: BufferingSlider?
    
    override func draw(in ctx: CGContext) {
        if let slider = rangeSlider {
            let thumbFrame = bounds.insetBy(dx: 0.0, dy: 0.0)
            let cornerRadius = thumbFrame.height * slider.curvaceousness / 2.0
            let thumbPath = UIBezierPath(roundedRect: thumbFrame, cornerRadius: cornerRadius)
            
            ctx.setFillColor(slider.thumbTintColor.cgColor)
            ctx.addPath(thumbPath.cgPath)
            ctx.fillPath()
        }
    }
}

class BufferingSliderTrackLayer: CALayer {
    weak var rangeSlider: BufferingSlider?
    
    override func draw(in ctx: CGContext) {
        if let slider = rangeSlider {
            
            masksToBounds = true
            cornerRadius = bounds.height * slider.curvaceousness / 2.0
            
            // Clip
            let lowerValuePosition   = CGFloat(slider.positionForValue(value: slider.value))
            let upperValuePosition   = CGFloat(slider.positionForValue(value: slider.bufferValue))
            
            // Fill the track
            ctx.setFillColor(slider.trackTintColor.cgColor)
            ctx.addPath(UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius ).cgPath)
            ctx.fillPath()
            
            // Fill the highlighted range
            ctx.setFillColor(slider.trackHighlightTintColor.cgColor)
            ctx.fill( CGRect(x: lowerValuePosition, y: 0.0, width: upperValuePosition - lowerValuePosition, height: bounds.height) )
            
            // Fill the Progress range
            ctx.setFillColor(slider.trackHighlightTintColorP.cgColor)
            if slider.isRepeatMode {
                let repeatAValuePosition = CGFloat(slider.positionForValue(value: slider.repeatStartValue, isRepeat: true))
                let width = lowerValuePosition - repeatAValuePosition
                ctx.fill( CGRect(x: repeatAValuePosition, y: 0.0, width: width > 0 ? width : 0, height: bounds.height) )
                
            }else{
                ctx.fill( CGRect(x: 0.0, y: 0.0, width: lowerValuePosition, height: bounds.height) )
            }
            
        }
    }
}
