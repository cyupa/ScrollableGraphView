
import UIKit

internal class LabelPool<T: UIView> {
    typealias labelType = T

    var labels = [T]()
    var relations = [Int : Int]()
    var unused = [Int]()

    func deactivateLabel(forPointIndex pointIndex: Int){

        if let unusedLabelIndex = relations[pointIndex] {
            unused.append(unusedLabelIndex)
        }
        relations[pointIndex] = nil
    }

    func activateLabel(forPointIndex pointIndex: Int) -> T {
        var label: T

        if(unused.count >= 1) {
            let unusedLabelIndex = unused.first!
            unused.removeFirst()

            label = labels[unusedLabelIndex]
            relations[pointIndex] = unusedLabelIndex
        }
        else {
            label = T()
            labels.append(label)
            let newLabelIndex = labels.index(of: label)!
            relations[pointIndex] = newLabelIndex
        }

        return label
    }

    var activeLabels: [T] {
        get {

            var currentlyActive = [T]()
            let numberOfLabels = labels.count

            for i in 0 ..< numberOfLabels {
                if(!unused.contains(i)) {
                    currentlyActive.append(labels[i])
                }
            }
            return currentlyActive
        }
    }
}

internal class TextLabelPool: LabelPool<UILabel> {

    var labelColor = UIColor.black
    var labelFont = UIFont.systemFont(ofSize: 10)
    
    @discardableResult
    override func activateLabel(forPointIndex pointIndex: Int) -> UILabel {
        let label = super.activateLabel(forPointIndex: pointIndex)
        label.textColor = labelColor
        label.font = labelFont

        return label
    }

}
