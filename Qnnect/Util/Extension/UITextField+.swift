//
//  UITextField+.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/13.
//

import UIKit

extension UITextField {
    //textField UnderLine 그리기
    func drawUnderLine() {
        let border = CALayer()
        border.frame = CGRect(
            x: 0,
            y: self.frame.size.height + 5.0,
            width: self.frame.width, height: 1
        )
        border.borderWidth = 1
        border.backgroundColor = UIColor.black.cgColor
        self.layer.addSublayer(border)
    }
}
