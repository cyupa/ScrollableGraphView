
import UIKit

// Delegate definition that provides the data required by the drawing layers.
internal protocol ScrollableGraphViewDrawingDelegate {
    func intervalForActivePoints() -> CountableRange<Int>
    func rangeForActivePoints() -> (min: Double, max: Double)
    func paddingForPoints() -> (leftmostPointPadding: CGFloat, rightmostPointPadding: CGFloat)
    func calculatePosition(atIndex index: Int, value: Double) -> CGPoint
    func datum(forIndex index: Int) -> Any?
    func currentViewport() -> CGRect
    func updatePaths()
}
