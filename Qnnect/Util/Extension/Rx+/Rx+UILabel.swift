//
//  UILabel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/14.
//

import UIKit
import RxSwift

extension Reactive where Base: UILabel {
    public var nameLength: Binder<Int> {
        return Binder(self.base) { label, length in
            label.text = "\(length) / \(Constants.nameMaxLength)"
        }
    }
}
