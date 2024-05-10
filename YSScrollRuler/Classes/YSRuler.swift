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

public class YSRuler: UIView, RulerViewUtilProtocol {
    public struct Info: ScrollRulerProtocol {
        public var minValue: CGFloat
        public var maxValue: CGFloat
        public var step: CGFloat
        public var dividerCount: Int
        public var unit: String?
        public var leftOffset: CGFloat = 0
    }

    public var rulerInfo: Info? {
        didSet {
            setNeedsDisplay()
        }
    }

    public var appearance = RulerAppearance()
    private lazy var rulerHeight: CGFloat = frame.size.height

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func draw(_: CGRect) {
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

        layer.addSublayer(shaperLayer(
            of: path,
            with: appearance.horizontalLineColor,
            lineWidth: appearance.horizontalLineHeight
        ))
    }

    func drawScale() {
        guard let rulerInfo else {
            return
        }

        let path = UIBezierPath()
        path.lineWidth = appearance.scaleWidth
        path.lineCapStyle = .butt
        path.lineJoinStyle = .round

        guard rulerInfo.maxValue > rulerInfo.minValue else {
            return
        }

        let minValue = rulerInfo.minValue
        let totalDividerCount = Int(ceil((rulerInfo.maxValue - minValue) / rulerInfo.step))
        let longSpaceValue = rulerInfo.step * CGFloat(rulerInfo.dividerCount)
        for idx in 0 ... totalDividerCount {
            let x = rulerInfo.leftOffset + CGFloat(appearance.scaleSpace * CGFloat(idx))
            path.move(to: CGPoint(x: x, y: rulerHeight - appearance.horizontalLineHeight))

            var h = appearance.shortScaleHeight
            let value = minValue + CGFloat(idx) * rulerInfo.step
            if value.truncatingRemainder(dividingBy: longSpaceValue) == 0 {
                h = appearance.longScaleHeight
                // draw text
                if appearance.textVisual {
                    drawDividingTextAtIndex(idx, minValue: minValue)
                }
            }

            let y = rulerHeight - CGFloat(h) - appearance.horizontalLineHeight
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.close()

        layer.addSublayer(shaperLayer(of: path, with: appearance.scaleColor, lineWidth: appearance.scaleWidth))
    }

    func drawDividingTextAtIndex(_ index: Int, minValue: CGFloat) {
        guard let rulerInfo else {
            return
        }

        let num = ceil(CGFloat(index) * rulerInfo.step + minValue)
        let text = String(format: "%zd%@", Int(num), rulerInfo.unit ?? "")
        let attribute: [NSAttributedString.Key: Any] = [
            .font: appearance.scaleTextFont,
            .foregroundColor: appearance.scaleColor,
        ]
        let textSize = boundingRect(of: text, attributes: attribute)
        let lineCenterX = CGFloat(appearance.scaleSpace)
        let x = ceil(rulerInfo.leftOffset + lineCenterX * CGFloat(index) - textSize.width / 2)
        let y = rulerHeight - CGFloat(appearance.longScaleHeight) - appearance.horizontalLineHeight - textSize.height
        text.draw(
            in: CGRect(x: x, y: y, width: textSize.width, height: textSize.height),
            withAttributes: attribute
        )
    }

    func shaperLayer(of path: UIBezierPath, with color: UIColor, lineWidth: CGFloat) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = lineWidth
        return shapeLayer
    }
}
