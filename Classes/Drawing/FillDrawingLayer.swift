
import UIKit

internal class FillDrawingLayer : ScrollableGraphViewDrawingLayer {
    
    private(set) var drawingLayer: ScrollableGraphViewDrawingLayer
    
    init(frame: CGRect, fillColor: UIColor, drawingLayer: ScrollableGraphViewDrawingLayer) {
        
        self.drawingLayer = drawingLayer
        super.init(viewportWidth: frame.size.width, viewportHeight: frame.size.height)
        self.fillColor = fillColor.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createBezierPath() -> UIBezierPath {
        return drawingLayer.createBezierPath()
    }
    
    override func updatePath() {
        self.path = createBezierPath().cgPath
    }
}
