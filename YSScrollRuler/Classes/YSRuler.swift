//
// *************************************************
// Created by Joseph Koh on 2023/11/6.
// Author: Joseph Koh
// Email: Joseph0750@gmail.com
// Create Time: 2023/11/6 10:03
// Copyright (c) 2023 Joseph Koh. All rights reserved.
// *************************************************
//

import UIKit

// MARK: - YSRuler

class YSRuler: UIView, RulerViewUtilProtocol {
    public struct Info: ScrollRulerProtocol {
        public var padding: CGFloat
        public var minValue: CGFloat
        public var maxValue: CGFloat
        public var step: CGFloat
        public var dividerCount: Int
        public var unit: String?
        public var textVisual = true

        public init(
            padding: CGFloat,
            minValue: CGFloat,
            maxValue: CGFloat,
            step: CGFloat,
            dividerCount: Int,
            unit: String? = nil,
            textVisual: Bool = true
        ) {
            self.padding = padding
            self.minValue = minValue
            self.maxValue = maxValue
            self.step = step
            self.dividerCount = dividerCount
            self.unit = unit
            self.textVisual = textVisual
        }
    }

    public var rulerInfo: Info? {
        didSet {
            setNeedsDisplay()
        }
    }

    private let appearance = RulerAppearance.appearance
    private lazy var rulerHeight: CGFloat = frame.size.height

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_: CGRect) {
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        drawHorizontalLine()
        drawScale()
    }
}

private extension YSRuler {
    func drawHorizontalLine() {
        let path = UIBezierPath()
        path.lineWidth = appearance.horizontalLineHeight
        path.lineCapStyle = .butt
        path.lineJoinStyle = .round
        let horizontalLineY = frame.size.height - appearance.lineWidth
        path.move(to: CGPoint(x: 0, y: horizontalLineY))
        path.addLine(to: CGPoint(x: frame.size.width, y: horizontalLineY))
        path.close()

        layer.addSublayer(shaperLayer(of: path, with: appearance.horizontalLineColor))
    }

    func drawScale() {
        guard let rulerInfo else {
            return
        }

        let path = UIBezierPath()
        path.lineWidth = appearance.horizontalLineHeight
        path.lineCapStyle = .butt
        path.lineJoinStyle = .round

        guard rulerInfo.maxValue > rulerInfo.minValue else {
            return
        }
        let totalDividerCount = Int(ceil((rulerInfo.maxValue - rulerInfo.minValue) / rulerInfo.step))
        for idx in 0 ... totalDividerCount {
            let x = CGFloat(rulerInfo.padding + CGFloat(appearance.scaleSpace * idx))
            path.move(to: CGPoint(x: x, y: rulerHeight - appearance.horizontalLineHeight))

            var h = appearance.shortScaleHeight
            let value = rulerInfo.minValue + CGFloat(idx) * rulerInfo.step
            if value.truncatingRemainder(dividingBy: rulerInfo.step * CGFloat(rulerInfo.dividerCount)) == 0 {
                h = appearance.longScaleHeight
                if rulerInfo.textVisual == true {
                    drawDividingTextAtIndex(idx) // draw text
                }
            }

            let y = rulerHeight - CGFloat(h) - appearance.horizontalLineHeight
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.close()

        layer.addSublayer(shaperLayer(of: path, with: appearance.scaleColor))
    }

    func drawDividingTextAtIndex(_ index: Int) {
        guard let rulerInfo else {
            return
        }

        let num = ceil(CGFloat(index) * rulerInfo.step + rulerInfo.minValue)
        let text = String(format: "%zd%@", Int(num), rulerInfo.unit ?? "")
        let attribute: [NSAttributedString.Key: Any] = [
            .font: RulerAppearance.appearance.scaleTextFont,
            .foregroundColor: appearance.scaleColor,
        ]
        let textSize = boundingRect(of: text, attributes: attribute)
        let lineCenterX = CGFloat(appearance.scaleSpace)
        let x = ceil(rulerInfo.padding + lineCenterX * CGFloat(index) - textSize.width / 2)
        let y = rulerHeight - CGFloat(appearance.longScaleHeight) - appearance.horizontalLineHeight - textSize.height
        text.draw(
            in: CGRect(x: x, y: y, width: textSize.width, height: textSize.height),
            withAttributes: attribute
        )
    }

    func shaperLayer(of path: UIBezierPath, with color: UIColor) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = appearance.horizontalLineHeight
        return shapeLayer
    }
}
