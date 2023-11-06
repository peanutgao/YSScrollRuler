//
// *************************************************
// Created by Joseph Koh on 2023/11/3.
// Author: Joseph Koh
// Email: Joseph0750@gmail.com
// Create Time: 2023/11/3 18:04
// Copyright (c) 2023 Joseph Koh. All rights reserved.
// *************************************************
//

import UIKit

protocol RulerViewUtilProtocol: NSObjectProtocol {
    func boundingRect(of text: String?, attributes: [NSAttributedString.Key: Any]?) -> CGSize
}

extension RulerViewUtilProtocol where Self: UIView {
    func boundingRect(of text: String?, attributes: [NSAttributedString.Key: Any]?) -> CGSize {
        guard let text, text.count > 0 else {
            return .zero
        }
        let size = text.boundingRect(
                with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
                options: .truncatesLastVisibleLine,
                attributes: attributes,
                context: nil).size
        return CGSizeMake(ceil(size.width), ceil(size.height))
    }
}
