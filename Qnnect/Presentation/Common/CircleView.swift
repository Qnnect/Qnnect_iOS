//
//  CircleView.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/23.
//

import UIKit

class CircleView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2.0
        layer.masksToBounds = true
    }
}

class CircleImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2.0
        layer.masksToBounds = true
    }
}
