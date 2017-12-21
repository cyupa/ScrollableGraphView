//
//  ViewLabelPool.swift
//  GraphView
//
//  Created by Ciprian Redinciuc on 20/12/2017.
//

import UIKit

internal class DetailedView: UIView {
    let imageView: UIImageView
    let label: UILabel

    convenience init() {
        let rect = CGRect(x: 0, y: 0, width: 35, height: 45)
        self.init(frame: rect)
    }

    override init(frame: CGRect) {
        let labelRect = CGRect(x: 0, y: 0, width: 35, height: 20)
        label = UILabel(frame: labelRect)
        label.textAlignment = .center


        let imageRect = CGRect(x: 0, y: labelRect.height, width: 35, height: 25)
        imageView = UIImageView(frame: imageRect)
        imageView.contentMode = .scaleAspectFit

        super.init(frame: frame)
        self.addSubview(imageView)
        self.addSubview(label)

        let views: [String: Any] = [
            "imageView" : imageView,
            "label" : label
        ]

        var constraints: [NSLayoutConstraint] = []

        let verticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[label(20)]-0-[imageView]-0-|",
            metrics: nil,
            views: views)
        constraints += verticalConstraints

        let horizontalLabelConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[label]-0-|",
            metrics: nil,
            views: views)
        constraints += horizontalLabelConstraints

        let horizontalImageViewConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[imageView]-0-|",
            metrics: nil,
            views: views)
        constraints += horizontalImageViewConstraints

        NSLayoutConstraint.activate(constraints)

    }

    required convenience init?(coder aDecoder: NSCoder) {
        let rect = CGRect(x: 0, y: 0, width: 35, height: 45)
        self.init(frame: rect)
    }
}

internal class ViewLabelPool: LabelPool<DetailedView> {

    var labelColor = UIColor.black
    var labelFont = UIFont.systemFont(ofSize: 10)

    @discardableResult
    override func activateLabel(forPointIndex pointIndex: Int) -> DetailedView {
        let view = super.activateLabel(forPointIndex: pointIndex)
        
        return view
    }

}
