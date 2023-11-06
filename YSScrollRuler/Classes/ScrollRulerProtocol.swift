//
// *************************************************
// Created by Joseph Koh on 2023/11/4.
// Author: Joseph Koh
// Email: Joseph0750@gmail.com
// Create Time: 2023/11/4 02:11
// Copyright (c) 2023 Joseph Koh. All rights reserved.
// *************************************************
//

import Foundation

protocol ScrollRulerProtocol {
    var minValue: CGFloat { get set }
    var maxValue: CGFloat { get set }
    /// 间隔值，每两条的间隔值
    var step: CGFloat { get set }
    /// 间隔个数，每两条相隔多少个
    var dividerCount: Int { get set }
    /// 显示的单位
    var unit: String? { get set }
}
