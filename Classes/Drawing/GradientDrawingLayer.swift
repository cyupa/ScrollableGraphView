
import UIKit

internal class GradientDrawingLayer : ScrollableGraphViewDrawingLayer {
    
    private var colors: [CGColor]
    private var locations: [CGFloat]
    private var gradientType: ScrollableGraphViewGradientType
    var gradientAngle = 0.0 {
        didSet {
            gradientAngle = max(min(gradientAngle, 360), 0)
        }
    }
    
    // Gradient fills are only used with lineplots and we need 
    // to know what the line looks like.
    private var lineDrawingLayer: LineDrawingLayer
    
    lazy private var gradientMask: CAShapeLayer = ({
        let mask = CAShapeLayer()
        
        mask.frame = CGRect(x: 0, y: 0, width: self.viewportWidth, height: self.viewportHeight)
        mask.fillRule = kCAFillRuleEvenOdd
//        mask.lineJoin = self.lineJoin
        
        return mask
    })()
    
    init(frame: CGRect, colors: [UIColor], locations: [CGFloat], gradientType: ScrollableGraphViewGradientType, /*lineJoin: String = kCALineJoinRound,*/ lineDrawingLayer: LineDrawingLayer) {
        var cgColors: [CGColor] = []
        colors.forEach { (currentUIColor) in
            cgColors.append(currentUIColor.cgColor)
        }
        self.colors = cgColors
        self.locations = locations
        self.gradientType = gradientType
//        self.lineJoin = lineJoin
        
        self.lineDrawingLayer = lineDrawingLayer
        
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
    
    override func updatePath() {
        gradientMask.path = lineDrawingLayer.createLinePath().cgPath
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
