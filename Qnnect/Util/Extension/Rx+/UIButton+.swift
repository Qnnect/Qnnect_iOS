//
//  UIButton+.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/14.
//

import RxSwift
import UIKit
import SwiftUI

extension Reactive where Base: UIButton {
    public var setEnabled: Binder<Bool> {
        return Binder(self.base) { button,flag in
            button.isEnabled = flag
            button.backgroundColor = flag ? .p_brown : .GRAY04
        }
    }
}


