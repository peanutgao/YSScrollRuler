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

public protocol ScrollRulerViewDelegate: NSObjectProtocol {
    func scrollRulerView(rulerView: ScrollRulerView, valueDidiChanged value: CGFloat)
}

public class ScrollRulerView: UIView {
    public struct Config: ScrollRulerProtocol {
        public var minValue: CGFloat
        public var maxValue: CGFloat
        public var step: CGFloat
        public var dividerCount: Int
        public var unit: String?

        public init(minValue: CGFloat, maxValue: CGFloat, step: CGFloat, dividerCount: Int, unit: String? = nil) {
            self.minValue = minValue
            self.maxValue = maxValue
            self.step = step
            self.dividerCount = dividerCount
            self.unit = unit
        }
    }

    public var appearance = RulerAppearance.appearance
    public var config: ScrollRulerView.Config?
    private var _config: ScrollRulerView.Config! {
        get {
            config ?? Config(
                    minValue: 0,
                    maxValue: 0,
                    step: 0,
                    dividerCount: 0,
                    unit: nil
            )
        }
    }

    public weak var delegate: ScrollRulerViewDelegate?
    public private(set) var currentValue: CGFloat = 0

    public init(frame: CGRect, config: Config, appearanceConfig: ((RulerAppearance) -> ())? = nil) {
        super.init(frame: frame)
        self.config = config

        backgroundColor = UIColor.white
        appearanceConfig?(RulerAppearance.appearance)

        addSubview(scrollView)
        addSubview(indicatorView)

        let height = appearance.rulerHeight
        indicatorView.frame = CGRect(
                x: bounds.size.width / 2 - 0.5 - appearance.triangleWidth / 2,
                y: 0,
                width: appearance.triangleWidth,
                height: height
        )
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView(frame: self.bounds)
//        sv.showsVerticalScrollIndicator = false
//        sv.showsHorizontalScrollIndicator = false
        sv.bounces = true
        sv.backgroundColor = UIColor.clear
        sv.delegate = self
        return sv
    }()

    private lazy var indicatorView = RulerIndicatorView()
    private lazy var totalPadding: CGFloat = bounds.size.width

    public func setDefaultValue(_ defaultValue: CGFloat, animated: Bool) {
        let offsetX = totalPadding * 0.5 + ((defaultValue - _config.minValue) / _config.step) * CGFloat(appearance.scaleSpace)
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: animated)
    }

    public func update() {
        scrollView.subviews.forEach({ $0.removeFromSuperview() })

        let width = ((_config.maxValue - _config.minValue) / _config.step) * CGFloat(appearance.scaleSpace) + totalPadding
        scrollView.contentSize = CGSize(
                width: width,
                height: appearance.rulerHeight
        )

        let rulerItemView = YSRuler(frame: CGRect(
                x: 0,
                y: 0,
                width: width,
                height: appearance.rulerHeight * 0.5))
        rulerItemView.rulerInfo = .init(
                padding: bounds.size.width * 0.5,
                minValue: _config.minValue,
                maxValue: _config.maxValue,
                step: _config.step,
                dividerCount: _config.dividerCount,
                unit: _config.unit)
        scrollView.addSubview(rulerItemView)
        rulerItemView.setNeedsDisplay()
    }
}

private extension ScrollRulerView {

    @objc func setRealValueAndAnimated(realValue: CGFloat, animated: Bool) {
        scrollView.setContentOffset(
                CGPoint(x: Int(realValue) * appearance.scaleSpace, y: 0),
                animated: animated)
    }
}

// MARK: - UIScrollViewDelegate Delegate

extension ScrollRulerView: UIScrollViewDelegate {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let minValue = _config.minValue
        let maxValue = _config.maxValue
        let value = scrollView.contentOffset.x / CGFloat(appearance.scaleSpace)
        let step = _config.step
        let totalValue = CGFloat(value) * step + minValue

        if totalValue >= maxValue {
            currentValue = maxValue
        } else if totalValue <= minValue {
            currentValue = minValue
        } else {
            currentValue = value * step + minValue
        }
        delegate?.scrollRulerView(rulerView: self, valueDidiChanged: currentValue)
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            setRealValueAndAnimated(
                    realValue: scrollView.contentOffset.x / CGFloat(appearance.scaleSpace),
                    animated: true
            )
        }
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setRealValueAndAnimated(
                realValue: scrollView.contentOffset.x / CGFloat(appearance.scaleSpace),
                animated: true
        )
    }
}
