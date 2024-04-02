//
// *************************************************
// Created by Joseph Koh on 2023/11/3.
// Author: Joseph Koh
// Email: Joseph0750@gmail.com
// Create Time: 2023/11/3 16:47
// Copyright (c) 2023 Joseph Koh. All rights reserved.
// *************************************************
//

import UIKit

public class RulerIndicatorView: UIView {
    public var triangleWidth: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    public var indicatorColor = UIColor.blue {
        didSet {
            setNeedsDisplay()
        }
    }

    override public func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.lineJoinStyle = .round
        path.lineCapStyle = .round
        path.lineWidth = 2.0

        let centerX = rect.size.width * 0.5
        let triangleTopPoint = CGPoint(x: centerX, y: rect.size.height - triangleWidth * 0.5)
        let startPoint = CGPoint(x: centerX, y: 0)
        path.move(to: startPoint)
        path.addLine(to: triangleTopPoint)
        path.addLine(to: CGPoint(x: 0, y: rect.size.height))
        path.addLine(to: CGPoint(x: rect.size.width, y: rect.size.height))
        path.addLine(to: triangleTopPoint)
        path.addLine(to: startPoint)

        path.close()
        path.stroke()

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = indicatorColor.cgColor
        shapeLayer.strokeColor = indicatorColor.cgColor
        shapeLayer.lineWidth = 2.0 // Set border width
        layer.addSublayer(shapeLayer)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
