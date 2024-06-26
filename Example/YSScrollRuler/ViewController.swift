//
//  ViewController.swift
//  YSScrollRuler
//
//  Created by Joseph Koh on 11/06/2023.
//  Copyright (c) 2023 Joseph Koh. All rights reserved.
//

import UIKit
import YSScrollRuler

// MARK: - ViewController

class ViewController: UIViewController {
    lazy var rulerView: YSScrollRulerView = { [unowned self] in
        let height: CGFloat = 200
        var rulerView = YSScrollRulerView(
            frame: CGRect(x: 5, y: 100, width: view.bounds.size.width - 20, height: height)){ appearance in
                appearance.textVisual = false
                appearance.indicatorColor = .green
            }
        rulerView.backgroundColor = .white
        rulerView.delegate = self
        return rulerView
    }()

    lazy var rulerView_layout: YSScrollRulerView = { [unowned self] in
        let rulerView = YSScrollRulerView(frame: .zero) { appearance in
            appearance.textVisual = true
        }
        rulerView.backgroundColor = .white
        rulerView.delegate = self
        rulerView.translatesAutoresizingMaskIntoConstraints = false

        return rulerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .lightGray

        rulerView.config = .init(
            minValue: 0,
            maxValue: 1000,
            step: 10,
            dividerCount: 10,
            unit: "¥"
        )
        view.addSubview(rulerView)

        // ---
        view.addSubview(rulerView_layout)
        NSLayoutConstraint.activate([
            rulerView_layout.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5),
            rulerView_layout.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5),
            rulerView_layout.topAnchor.constraint(equalTo: rulerView.bottomAnchor, constant: 20),
            rulerView_layout.heightAnchor.constraint(equalToConstant: 200),
        ])
        
        rulerView_layout.config = .init(
            minValue: 0,
            maxValue: 1000,
            step: 10,
            dividerCount: 10,
            unit: "¥"
        )
        rulerView.setValue(500, animated: true)

    }
}

// MARK: YSScrollRulerViewDelegate

extension ViewController: YSScrollRulerViewDelegate {
    func scrollRulerView(rulerView: YSScrollRulerView, valueCanChange value: CGFloat) -> Bool{true}
    func scrollRulerView(rulerView: YSScrollRulerView, valueDidChanged value: CGFloat){
        print(value)
    }
    func scrollRulerView(rulerView: YSScrollRulerView, valueDidEndChanged value: CGFloat) {
        print(value)
    }
}
