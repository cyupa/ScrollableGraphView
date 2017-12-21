
import UIKit

open class DotPlot : Plot {
    
    // Customisation
    // #############
    
    /// The shape to draw for each data point.
    open var dataPointType = ScrollableGraphViewDataPointType.circle
    /// The size of the shape to draw for each data point.
    open var dataPointSize: CGFloat = 5
    /// The colour with which to fill the shape.
    open var dataPointFillColor: UIColor = UIColor.black
    open var dataPointBorderColor: UIColor = UIColor.black
    /// If dataPointType is set to .Custom then you,can provide a closure to create any kind of shape you would like to be displayed instead of just a circle or square. The closure takes a CGPoint which is the centre of the shape and it should return a complete UIBezierPath.
    open var customDataPointPath: ((_ centre: CGPoint) -> UIBezierPath)?
    
    // Private State
    // #############
    
    private var dataPointLayer: DotDrawingLayer?
    
    public init(identifier: String) {
        super.init()
        self.identifier = identifier
    }
    
    override func layers(forViewport viewport: CGRect) -> [ScrollableGraphViewDrawingLayer?] {
        createLayersIfNeed(viewport: viewport)
        return [dataPointLayer]
    }
    
    private func createLayersIfNeed(viewport: CGRect) {
        guard dataPointLayer == nil else {
            return
        }
        
        dataPointLayer = DotDrawingLayer(
            frame: viewport,
            fillColor: dataPointFillColor,
            dataPointType: dataPointType,
            dataPointSize: dataPointSize,
            customDataPointPath: customDataPointPath)

        dataPointLayer?.owner = self
    }
}

public enum ScrollableGraphViewDataPointType : Int {
    case circle
    case square
    case custom
}
