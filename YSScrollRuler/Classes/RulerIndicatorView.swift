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

class RulerIndicatorView: UIView {

    private let appearance = RulerAppearance.appearance

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.lineJoinStyle = .round
        path.lineCapStyle = .round
        path.lineWidth = 2.0

        let centerX = rect.size.width * 0.5
        let triangleTopPoint = CGPoint(x: centerX, y: rect.size.height - appearance.triangleWidth * 0.5)
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
        shapeLayer.fillColor = appearance.indicatorColor.cgColor
        shapeLayer.strokeColor = appearance.indicatorColor.cgColor
        shapeLayer.lineWidth = 2.0 // 设置边框宽度
        layer.addSublayer(shapeLayer)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
