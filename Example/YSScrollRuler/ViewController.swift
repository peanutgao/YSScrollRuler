//
//  ViewController.swift
//  YSScrollRuler
//
//  Created by Joseph Koh on 11/06/2023.
//  Copyright (c) 2023 Joseph Koh. All rights reserved.
//

import UIKit
import YSScrollRuler

class ViewController: UIViewController {


    lazy var rulerView: ScrollRulerView = { [unowned self] in
        let height: CGFloat = 200
        let unitStr = "¥"
        var rulerView = ScrollRulerView.init(
            frame: CGRect.init(x: 5, y: 100, width: view.bounds.size.width - 20, height: height),
            config: .init(
                minValue: 0,
                maxValue: 1000,
                step: 10, // 间隔值，每两条的间隔值
                dividerCount: 10,
                unit: unitStr
            ))
        rulerView.setDefaultValue(500, animated: true)
        rulerView.backgroundColor = .white
        rulerView.delegate = self
        return rulerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray

        view.addSubview(rulerView)
        rulerView.update()
    }

}

extension ViewController: ScrollRulerViewDelegate {
    func scrollRulerView(rulerView: YSScrollRuler.ScrollRulerView, valueDidiChanged value: CGFloat) {
        print(value)
    }
    
}
