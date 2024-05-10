//
// *************************************************
// Created by Joseph Koh on 2023/11/3.
// Author: Joseph Koh
// Email: Joseph0750@gmail.com
// Create Time: 2023/11/3 16:48
// Copyright (c) 2023 Joseph Koh. All rights reserved.
// *************************************************
//

import UIKit

public class RulerAppearance {
    public var textVisual = false
    public var scaleSpace: CGFloat = 15.0
    public var longScaleHeight: CGFloat = 15.0
    public var shortScaleHeight: CGFloat = 10.0
    public var scaleWidth: CGFloat = 2.0
    public var horizontalLineHeight: CGFloat = 1.0

    public var rulerHeight: CGFloat = 30
    public var rulerOffsetY = 0.0
    public var textColorWhiteAlpha: CGFloat = 1.0

    public var lineWidth: CGFloat = 1.0
    public var scaleTextFont = UIFont.systemFont(ofSize: 11)
    public var scaleColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.5)
    public var horizontalLineColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.1)
    
    public var indicatorColor = UIColor(red: 0.1, green: 0.46, blue: 0.95, alpha: 1)
    public var indicatorHeight = 55.0
    public var triangleWidth: CGFloat = 10.0
}
