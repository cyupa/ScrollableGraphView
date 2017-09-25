
import UIKit

public protocol ScrollableGraphViewDataSource {

    func numberOfPoints() -> Int
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double
    
    func xLabel(atIndex pointIndex: Int) -> String
    func yLabel(forPlot plot: Plot, atIndex pointIndex: Int) -> NSAttributedString?
    func yLabelOffset(forPlot plot: Plot) -> UIOffset?
    /// An affine transformation matrix for use in drawing 2D graphics.
    ///
    /// - Parameter plot: The current plot.
    /// - Returns: An angle of the rotate for the label. From 0 to 360 or nil. By default 0.
    func yLabelTransformAngle(forPlot plot: Plot) -> CGFloat?
}
