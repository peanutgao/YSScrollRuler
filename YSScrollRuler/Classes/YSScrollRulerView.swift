//
// *************************************************
// Created by Joseph Koh on 2023/11/4.
// Author: Joseph Koh
// Email: Joseph0750@gmail.com
// Create Time: 2023/11/4 01:12
// Copyright (c) 2023 Joseph Koh. All rights reserved.
// *************************************************
//

import UIKit

// MARK: - YSScrollRulerViewDelegate

public protocol YSScrollRulerViewDelegate: NSObjectProtocol {
    func scrollRulerView(rulerView: YSScrollRulerView, valueCanChange value: CGFloat) -> Bool
    func scrollRulerView(rulerView: YSScrollRulerView, valueDidChanged value: CGFloat)
    func scrollRulerView(rulerView: YSScrollRulerView, valueDidEndChanged value: CGFloat)
}

// MARK: - YSScrollRulerView

public class YSScrollRulerView: UIView {
    public struct Config: ScrollRulerProtocol {
        public var minValue: CGFloat
        public var maxValue: CGFloat
        public var step: CGFloat
        public var dividerCount: Int
        public var unit: String?
        public var defaultValue: CGFloat
        public var isScrollEnabled = true

        public init(
            minValue: CGFloat,
            maxValue: CGFloat,
            defaultValue: CGFloat? = nil,
            step: CGFloat,
            dividerCount: Int,
            unit: String? = nil,
            textVisual: Bool = false
        ) {
            self.minValue = minValue
            self.maxValue = maxValue
            self.defaultValue = defaultValue ?? minValue
            self.step = step
            self.dividerCount = dividerCount
            self.unit = unit
        }
    }

    public var appearance = RulerAppearance.appearance
    public var config: YSScrollRulerView.Config? {
        didSet {
            guard let config else {
                return
            }

            fixedMinValue = config.minValue

            if isNeedFexMinValue {
                let leftValue = (bounds.size.width * 0.5 / CGFloat(appearance.scaleSpace)) * config.step
                let adjustLeftValue = adjustValue(Int(leftValue), divisibleBy: Int(config.step))
                fixedMinValue -= CGFloat(adjustLeftValue)
            }

            _config = Config(
                minValue: CGFloat(fixedMinValue),
                maxValue: config.maxValue,
                defaultValue: config.defaultValue,
                step: config.step,
                dividerCount: config.dividerCount,
                unit: config.unit
            )
        }
    }

    private var _config: YSScrollRulerView.Config = Config(
        minValue: 0,
        maxValue: 0,
        step: 10,
        dividerCount: 0,
        unit: nil,
        textVisual: false
    )

    public weak var delegate: YSScrollRulerViewDelegate?
    public private(set) var currentValue: CGFloat = 0
    public private(set) var preValue: CGFloat = 0
    /// Set whether the minimum value should be displayed to the left of the scale when the minimum value is dragged
    /// to the center.
    public var isNeedFexMinValue = true

    private var fixedMinValue: CGFloat = 0
    private var fixValue: CGFloat = 0
    public let rulerView = YSRuler()
    public let indicatorView = RulerIndicatorView()

    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView(frame: .zero)
        sv.bounces = true
        sv.backgroundColor = UIColor.clear
        sv.delegate = self
        return sv
    }()

    public init(
        frame: CGRect = .zero,
        config: Config = .init(
            minValue: 0,
            maxValue: 0,
            step: 10,
            dividerCount: 5
        ),
        appearanceConfig: ((RulerAppearance) -> Void)? = nil
    ) {
        super.init(frame: frame)
        self.config = config

        backgroundColor = UIColor.white
        appearanceConfig?(appearance)

        currentValue = config.defaultValue

        scrollView.isScrollEnabled = config.isScrollEnabled
        addSubview(scrollView)
        scrollView.addSubview(rulerView)

        indicatorView.indicatorColor = appearance.indicatorColor
        indicatorView.triangleWidth = appearance.triangleWidth
        addSubview(indicatorView)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        scrollView.frame = bounds

        indicatorView.center = CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)
        indicatorView.bounds = CGRect(x: 0, y: 0, width: appearance.triangleWidth, height: appearance.indicatorHeight)
        reload()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension YSScrollRulerView {
    func reload() {
        guard _config.step != 0 else {
            return
        }
        let width = ((_config.maxValue - fixedMinValue) / _config.step) * CGFloat(appearance.scaleSpace)
        scrollView.contentSize = CGSize(width: width, height: appearance.rulerHeight)

        rulerView.frame = CGRect(
            x: 0,
            y: (bounds.size.height - appearance.rulerHeight) * 0.5 + appearance.rulerOffsetY,
            width: CGFloat.maximum(scrollView.bounds.size.width, width),
            height: appearance.rulerHeight
        )
        rulerView.rulerInfo = .init(
            minValue: fixedMinValue,
            maxValue: _config.maxValue,
            step: _config.step,
            dividerCount: _config.dividerCount,
            unit: _config.unit
        )
        rulerView.layoutIfNeeded()

        currentValue = _config.defaultValue
        preValue = currentValue
        setValue(_config.defaultValue, animated: false)
    }

    func setValue(_ value: CGFloat, animated: Bool) {
        let offsetX = ((value - fixedMinValue) / _config.step) * CGFloat(appearance.scaleSpace)
        var fixed = offsetX
        if _config.step != 0 {
            fixed -= ((fixValue / _config.step) * CGFloat(appearance.scaleSpace))
        }
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: animated)
    }
}

private extension YSScrollRulerView {
    @objc func offsetView(by offsetX: CGFloat, animated: Bool) {
        let scaleCount = calculateScaleCount(by: offsetX)
        var fixed = CGFloat(scaleCount * appearance.scaleSpace)
        if _config.step != 0 {
            fixed -= ((fixValue / _config.step) * CGFloat(appearance.scaleSpace))
        }
        scrollView.setContentOffset(CGPoint(x: fixed, y: 0), animated: animated)
    }

    func calculateScaleCount(by offsetX: CGFloat) -> Int {
        Int(round(offsetX / CGFloat(appearance.scaleSpace)))
    }

    func calculateOffsetX(by value: CGFloat?) -> CGFloat {
        guard let value, value >= fixedMinValue else {
            return 0.0
        }
        return (value - fixedMinValue) / CGFloat(_config.step) * CGFloat(appearance.scaleSpace)
    }
}

// MARK: UIScrollViewDelegate

extension YSScrollRulerView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let minValue = fixedMinValue
        let maxValue = _config.maxValue
        let scaleCount = calculateScaleCount(by: scrollView.contentOffset.x)
        let step = _config.step
        let totalValue = CGFloat(scaleCount) * step + minValue

        if totalValue >= maxValue {
            currentValue = maxValue
        } else if totalValue <= minValue {
            currentValue = minValue
        } else {
            currentValue = CGFloat(scaleCount) * step + minValue
        }

        let b = delegate?.scrollRulerView(rulerView: self, valueCanChange: currentValue) ?? true
        if b == false {
            setValue(preValue, animated: false)
            currentValue = preValue
        } else {
            preValue = currentValue
        }

        delegate?.scrollRulerView(rulerView: self, valueDidChanged: currentValue)
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            offsetView(by: scrollView.contentOffset.x, animated: true)
            delegate?.scrollRulerView(rulerView: self, valueDidEndChanged: currentValue)
        }
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        offsetView(by: scrollView.contentOffset.x, animated: true)
        delegate?.scrollRulerView(rulerView: self, valueDidEndChanged: currentValue)
    }

    func adjustValue(_ value: Int, divisibleBy divisor: Int) -> Int {
        if value % divisor == 0 {
            return value
        } else {
            let remainder = value % divisor
            let fix = divisor - remainder
            fixValue = CGFloat(fix)
            return value + fix
        }
    }
}
