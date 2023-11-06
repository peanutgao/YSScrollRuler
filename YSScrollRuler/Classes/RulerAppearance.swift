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

public struct RulerAppearance {
    static let appearance = RulerAppearance()

    /// 刻度间距是12像素
    public let scaleSpace = 15
    /// 长刻度高度
    public let longScaleHeight = 20
    /// 短刻度高度
    public let shortScaleHeight = 10
    /// 刻度线宽度
    public let scaleWidth: CGFloat = 2.0
    public let horizontalLineHeight: CGFloat = 1.0

    public let rulerHeight: CGFloat = 70
    public let TextColorWhiteAlpha: CGFloat = 1.0

    public let lineWidth: CGFloat = 1.0
    /// 刻度文字
    public let scaleTextFont = UIFont.systemFont(ofSize: 11)
    /// 刻度颜色
    public let scaleColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
    public let indicatorColor = UIColor(red: 0.1, green: 0.46, blue: 0.95, alpha: 1)
    public let triangleWidth: CGFloat = 16.0
}
