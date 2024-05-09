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
            unit: String? = nil
        ) {
            self.minValue = minValue
            self.maxValue = maxValue
            self.defaultValue = defaultValue ?? minValue
            self.step = step
            self.dividerCount = dividerCount
            self.unit = unit
        }
    }

    public var appearance = RulerAppearance()
    public var config: Config? {
        didSet {
            guard let config = config else { return }
            _config = config
            reload()
        }
    }

    private var _config: Config!

    public weak var delegate: YSScrollRulerViewDelegate?
    public private(set) var currentValue: CGFloat = 0

    private let rulerView = YSRuler()
    private let indicatorView = RulerIndicatorView()
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView(frame: .zero)
        sv.bounces = true
        sv.backgroundColor = .clear
        sv.delegate = self
        return sv
    }()

    public init(frame: CGRect = .zero, config: Config, appearanceConfig: ((RulerAppearance) -> Void)? = nil) {
        super.init(frame: frame)
        self.config = config
        backgroundColor = .white
        appearanceConfig?(appearance)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(scrollView)
        scrollView.addSubview(rulerView)
        addSubview(indicatorView)
        applyAppearance()
    }

    private func applyAppearance() {
        indicatorView.indicatorColor = appearance.indicatorColor
        indicatorView.triangleWidth = appearance.triangleWidth
        scrollView.isScrollEnabled = _config?.isScrollEnabled ?? true
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        layoutScrollView()
        layoutIndicatorView()
        reload()
    }

    private func layoutScrollView() {
        scrollView.frame = bounds
    }

    private func layoutIndicatorView() {
        indicatorView.center = CGPoint(x: bounds.midX, y: bounds.midY)
        indicatorView.bounds = CGRect(x: 0, y: 0, width: appearance.triangleWidth, height: appearance.indicatorHeight)
    }

    public func reload() {
        guard let _config = _config, _config.step != 0 else { return }
        configureRulerView()
        setCurrentValue(_config.defaultValue, animated: false)
    }

    private func configureRulerView() {
        let width = ((_config.maxValue - _config.minValue) / _config.step) * CGFloat(appearance.scaleSpace)
        scrollView.contentSize = CGSize(width: width, height: appearance.rulerHeight)
        rulerView.frame = CGRect(
            x: 0,
            y: (bounds.height - appearance.rulerHeight) * 0.5 + appearance.rulerOffsetY,
            width: max(scrollView.bounds.width, width),
            height: appearance.rulerHeight
        )
        rulerView.rulerInfo = .init(
            minValue: _config.minValue,
            maxValue: _config.maxValue,
            step: _config.step,
            dividerCount: _config.dividerCount,
            unit: _config.unit
        )
        rulerView.appearance = appearance
    }

    public func setCurrentValue(_ value: CGFloat, animated: Bool) {
        guard _config != nil, value >= _config.minValue, value <= _config.maxValue else {
            return
        }
        let offsetX = ((value - _config.minValue) / _config.step) * CGFloat(appearance.scaleSpace)
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: animated)
    }

    public func setCurrentValue(_ value: Int, animated: Bool) {
        setCurrentValue(CGFloat(value), animated: animated)
    }
}

// MARK: UIScrollViewDelegate

extension YSScrollRulerView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        let value = calculateValue(fromOffset: offset)

        guard delegate?.scrollRulerView(rulerView: self, valueCanChange: value) ?? true else {
            setCurrentValue(currentValue, animated: false)
            return
        }

        currentValue = value
        delegate?.scrollRulerView(rulerView: self, valueDidChanged: currentValue)
    }

    public func scrollViewDidEndDragging(_: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            finalizeScrolling()
        }
    }

    public func scrollViewDidEndDecelerating(_: UIScrollView) {
        finalizeScrolling()
    }

    private func finalizeScrolling() {
        setCurrentValue(currentValue, animated: true)
        delegate?.scrollRulerView(rulerView: self, valueDidEndChanged: currentValue)
    }

    private func calculateValue(fromOffset offset: CGFloat) -> CGFloat {
        let scaleCount = Int(round(offset / CGFloat(appearance.scaleSpace)))
        let value = CGFloat(scaleCount) * _config.step + _config.minValue
        return min(max(value, _config.minValue), _config.maxValue)
    }
}
