
import UIKit

internal class GradientDrawingLayer : ScrollableGraphViewDrawingLayer {
    
    private(set) var colors: [CGColor]
    private(set) var locations: [CGFloat]
    private(set) var gradientType: ScrollableGraphViewGradientType
    private(set) var drawingLayer: ScrollableGraphViewDrawingLayer
    private(set) var gradientAngle: Double {
        didSet {
            gradientAngle = max(min(gradientAngle, 360), 0)
        }
    }
    
    lazy private var gradientMask: CAShapeLayer = ({
        let mask = CAShapeLayer()
        
        mask.frame = CGRect(x: 0, y: 0, width: self.viewportWidth, height: self.viewportHeight)
        mask.fillRule = kCAFillRuleEvenOdd
        
        return mask
    })()
    
    init(frame: CGRect, colors: [UIColor], locations: [CGFloat], gradientType: ScrollableGraphViewGradientType, gradientAngle: Double, drawingLayer: ScrollableGraphViewDrawingLayer) {
        var cgColors: [CGColor] = []
        colors.forEach { (currentUIColor) in
            cgColors.append(currentUIColor.cgColor)
        }
        self.gradientAngle = gradientAngle
        self.colors = cgColors
        self.locations = locations
        self.gradientType = gradientType
        
        self.drawingLayer = drawingLayer
        
        super.init(viewportWidth: frame.size.width, viewportHeight: frame.size.height)
        
        addMaskLayer()
        self.setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addMaskLayer() {
        self.mask = gradientMask
    }
    
    override func createBezierPath() -> UIBezierPath {
        return drawingLayer.createBezierPath()
    }
    
    override func updatePath() {
        gradientMask.path = createBezierPath().cgPath
    }
    
    override func draw(in ctx: CGContext) {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)
        
        let degree = CGFloat(gradientAngle * Double.pi / 180)
        let center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        let startPoint = CGPoint(x: center.x - cos(degree) * frame.width / 2,
                                 y: center.y - sin(degree) * frame.height / 2)
        let endPoint = CGPoint(x: center.x + cos(degree) * frame.width / 2,
                               y: center.y + sin(degree) * frame.height / 2)
        let startRadius: CGFloat = 0
        let endRadius: CGFloat = self.bounds.width
        
        switch(gradientType) {
        case .linear:
            ctx.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: .drawsAfterEndLocation)
        case .radial:
            ctx.drawRadialGradient(gradient!, startCenter: startPoint, startRadius: startRadius, endCenter: endPoint, endRadius: endRadius, options: .drawsAfterEndLocation)
        }
    }
}
