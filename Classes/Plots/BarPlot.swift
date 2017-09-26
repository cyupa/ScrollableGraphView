
import UIKit

open class BarPlot : Plot {
    
    // Customisation
    // #############
    
    /// The width of an individual bar on the graph.
    open var barWidth: CGFloat = 25;
    /// The width of the outline of the bar
    open var barLineWidth: CGFloat = 1
    /// The colour of the bar outline
    open var barLineColor: UIColor = UIColor.darkGray
    /// Whether the bars should be drawn with rounded corners
    open var shouldRoundBarCorners: Bool = false
    
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
    
    private var barLayer: BarDrawingLayer?
    private var fillLayer: FillDrawingLayer?
    private var gradientLayer: GradientDrawingLayer?
    
    public init(identifier: String) {
        super.init()
        self.identifier = identifier
    }

    override func layers(forViewport viewport: CGRect) -> [ScrollableGraphViewDrawingLayer?] {
        createLayersIfNeed(viewport: viewport)
        return [barLayer, fillLayer, gradientLayer]
    }
    
    private func createLayersIfNeed(viewport: CGRect) {
        guard barLayer == nil else {
            return
        }

        // Create the bar drawing layer.
        barLayer = BarDrawingLayer(
            frame: viewport,
            barWidth: barWidth,
            barLineWidth: barLineWidth,
            barLineColor: barLineColor,
            shouldRoundCorners: shouldRoundBarCorners)
        
        // Depending on whether we want to fill with solid or gradient, create the layer accordingly.
        
        // Gradient and Fills
        switch (self.fillType) {
            
        case .solid:
            if(shouldFill) {
                // Setup fill
                fillLayer = FillDrawingLayer(frame: viewport, fillColor: fillColor, drawingLayer: barLayer!)
            }
            
        case .gradient:
            if(shouldFill) {
                let locations = fillGradientColors.keys.sorted()
                var colors: [UIColor] = []
                locations.forEach({ (location) in
                    colors.append(fillGradientColors[location]!)
                })
                gradientLayer = GradientDrawingLayer(frame: viewport, colors: colors, locations: locations, gradientType: fillGradientType, gradientAngle: fillGradientAngle, drawingLayer: barLayer!)
            }
        }
        
        barLayer?.owner = self
        fillLayer?.owner = self
        gradientLayer?.owner = self
    }
}
