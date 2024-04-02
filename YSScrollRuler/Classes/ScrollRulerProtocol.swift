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
    var step: CGFloat { get set }
    var dividerCount: Int { get set }
    var unit: String? { get set }
}
