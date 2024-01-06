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
    func scrollRulerView(rulerView: YSScrollRulerView, valueDidiChanged value: CGFloat)
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
        public var textVisual = true
        public var defaultValue: CGFloat
        public var isScrollEnabled = true

        public init(
            minValue: CGFloat,
            maxValue: CGFloat,
            defaultValue: CGFloat? = nil,
            step: CGFloat,
            dividerCount: Int,
            unit: String? = nil,
            textVisual: Bool = true,
            isScrollEnabled: Bool = true
        ) {
            self.minValue = minValue
            self.maxValue = maxValue
            self.defaultValue = defaultValue ?? minValue
            self.step = step
            self.dividerCount = dividerCount
            self.unit = unit
            self.textVisual = textVisual
            self.isScrollEnabled = isScrollEnabled
        }
    }

    public var isScrollEnabled = true {
        didSet {
            scrollView.isScrollEnabled = isScrollEnabled
        }
    }

    public var appearance = RulerAppearance.appearance
    public var config: YSScrollRulerView.Config?
    private var _config: YSScrollRulerView.Config! {
        config ?? Config(
            minValue: 0,
            maxValue: 0,
            step: 10,
            dividerCount: 0,
            unit: nil,
            textVisual: true,
            isScrollEnabled: true
        )
    }

    public weak var delegate: YSScrollRulerViewDelegate?
    public private(set) var currentValue: CGFloat = 0

    public init(frame: CGRect, config: Config, appearanceConfig: ((RulerAppearance) -> Void)? = nil) {
        super.init(frame: frame)
        self.config = config

        backgroundColor = UIColor.white
        appearanceConfig?(RulerAppearance.appearance)

        scrollView.isScrollEnabled = config.isScrollEnabled
        addSubview(scrollView)
        addSubview(indicatorView)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        scrollView.frame = bounds
        indicatorView.frame = CGRect(
            x: bounds.size.width / 2 - 0.5 - appearance.triangleWidth / 2,
            y: 0,
            width: appearance.triangleWidth,
            height: appearance.rulerHeight
        )
        reload()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView(frame: .zero)
//        sv.showsVerticalScrollIndicator = false
//        sv.showsHorizontalScrollIndicator = false
        sv.bounces = true
        sv.backgroundColor = UIColor.clear
        sv.delegate = self
        return sv
    }()

    private lazy var indicatorView = RulerIndicatorView()
    private var padding: CGFloat {
        bounds.size.width * 0.5
    }
}

public extension YSScrollRulerView {
    func setValue(_ value: CGFloat, animated: Bool) {
        let offsetX = ((value - _config.minValue) / _config.step) * CGFloat(appearance.scaleSpace) + padding
        scrollView.setContentOffset(CGPoint(x: round(offsetX), y: 0), animated: animated)
    }

    func reload() {
        scrollView.subviews.forEach {
            $0.removeFromSuperview()
        }

        guard _config.step != 0 else {
            return
        }
        let width = ((_config.maxValue - _config.minValue) / _config.step) * CGFloat(appearance.scaleSpace) + padding *
            2
        scrollView.contentSize = CGSize(
            width: width,
            height: appearance.rulerHeight
        )

        let rulerViewH = appearance.rulerHeight * 0.5
        let rulerView = YSRuler(frame: CGRect(
            x: 0,
            y: 15, // indicator margin
            width: width,
            height: rulerViewH
        ))
        rulerView.rulerInfo = .init(
            padding: padding,
            minValue: _config.minValue,
            maxValue: _config.maxValue,
            step: _config.step,
            dividerCount: _config.dividerCount,
            unit: _config.unit,
            textVisual: _config.textVisual
        )
        scrollView.addSubview(rulerView)
        rulerView.setNeedsDisplay()

        scrollView.contentOffset = CGPointMake(calculateOffsetX(by: _config.defaultValue), 0)
    }
}

private extension YSScrollRulerView {
    @objc func offsetView(by offsetX: CGFloat, animated: Bool) {
        let scaleCount = calculateScaleCount(by: offsetX)
        let fixed = CGFloat(scaleCount * appearance.scaleSpace)
        scrollView.setContentOffset(CGPoint(x: fixed, y: 0), animated: animated)
    }

    func calculateScaleCount(by offsetX: CGFloat) -> Int {
        Int(round(offsetX / CGFloat(appearance.scaleSpace)))
    }

    func calculateOffsetX(by value: CGFloat?) -> CGFloat {
        guard let value, value >= _config.minValue else {
            return 0.0
        }
        return (value - _config.minValue) / CGFloat(_config.step) * CGFloat(appearance.scaleSpace)
    }
}

// MARK: UIScrollViewDelegate

extension YSScrollRulerView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let minValue = _config.minValue
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
        delegate?.scrollRulerView(rulerView: self, valueDidiChanged: currentValue)
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
}
