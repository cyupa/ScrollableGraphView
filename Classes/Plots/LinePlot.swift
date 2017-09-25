
import UIKit

open class LinePlot : Plot {
    
    // Public settings for the LinePlot
    // ################################
    
    /// Specifies how thick the graph of the line is. In points.
    open var lineWidth: CGFloat = 2
    
    /// The color of the graph line. UIColor.
    open var lineColor: UIColor = UIColor.black
    
    /// Whether the line is straight or curved.
    open var lineStyle_: Int {
        get { return lineStyle.rawValue }
        set {
            if let enumValue = ScrollableGraphViewLineStyle(rawValue: newValue) {
                lineStyle = enumValue
            }
        }
    }
    
    /// Whether or not the line should be rendered using bezier curves are straight lines.
    open var lineStyle = ScrollableGraphViewLineStyle.straight
    
    /// How each segment in the line should connect. Takes any of the Core Animation LineJoin values.
    open var lineJoin: String = kCALineJoinRound
    
    /// The line caps. Takes any of the Core Animation LineCap values.
    open var lineCap: String = kCALineCapRound
    open var lineCurviness: CGFloat = 0.5
    
    
    // Fill Settings
    // #############
    
    /// Specifies whether or not the plotted graph should be filled with a colour or gradient.
    open var shouldFill: Bool = false
    
    var fillType_: Int {
        get { return fillType.rawValue }
        set {
            if let enumValue = ScrollableGraphViewFillType(rawValue: newValue) {
                fillType = enumValue
            }
        }
    }
    
    /// Specifies whether to fill the graph with a solid colour or gradient.
    open var fillType = ScrollableGraphViewFillType.solid
    
    /// If fillType is set to .Solid then this colour will be used to fill the graph.
    open var fillColor: UIColor = UIColor.black
    
    /// If fillType is set to .Gradient then this will be the colours by the locations for the gradient.
    open var fillGradientColors: [CGFloat : UIColor] = [0.0 : UIColor.white, 1.0 : UIColor.black]
    
    open var fillGradientType_: Int {
        get { return fillGradientType.rawValue }
        set {
            if let enumValue = ScrollableGraphViewGradientType(rawValue: newValue) {
                fillGradientType = enumValue
            }
        }
    }
    
    /// If fillType is set to .Gradient, then this defines whether the gradient is rendered as a linear gradient or radial gradient.
    open var fillGradientType = ScrollableGraphViewGradientType.linear
    
    /// Rotate the gradient colors. Can be from 0.0 to 360.0.
    open var fillGradientAngle = 0.0
    
    // Private State
    // #############
    
    private var lineLayer: LineDrawingLayer?
    private var fillLayer: FillDrawingLayer?
    private var gradientLayer: GradientDrawingLayer?
    
    public init(identifier: String) {
        super.init()
        self.identifier = identifier
    }
    
    override func layers(forViewport viewport: CGRect) -> [ScrollableGraphViewDrawingLayer?] {
        createLayers(viewport: viewport)
        return [lineLayer, fillLayer, gradientLayer]
    }
    
    private func createLayers(viewport: CGRect) {
        
        // Create the line drawing layer.
        lineLayer = LineDrawingLayer(frame: viewport, lineWidth: lineWidth, lineColor: lineColor, lineStyle: lineStyle, lineJoin: lineJoin, lineCap: lineCap, shouldFill: shouldFill, lineCurviness: lineCurviness)
        
        // Depending on whether we want to fill with solid or gradient, create the layer accordingly.
        
        // Gradient and Fills
        switch (self.fillType) {
            
        case .solid:
            if(shouldFill) {
                // Setup fill
                fillLayer = FillDrawingLayer(frame: viewport, fillColor: fillColor, drawingLayer: lineLayer!)
            }
            
        case .gradient:
            if(shouldFill) {
                let locations = fillGradientColors.keys.sorted()
                var colors: [UIColor] = []
                locations.forEach({ (location) in
                    colors.append(fillGradientColors[location]!)
                })
                gradientLayer = GradientDrawingLayer(frame: viewport, colors: colors, locations: locations, gradientType: fillGradientType, gradientAngle: fillGradientAngle, drawingLayer: lineLayer!)
            }
        }
        
        lineLayer?.owner = self
        fillLayer?.owner = self
        gradientLayer?.owner = self
    }
}

@objc public enum ScrollableGraphViewLineStyle : Int {
    case straight
    case smooth
}
