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
            //TODO: 버튼 비활성화 STYLE 로직 추가 해야함 ex) 버튼 회색 으로 변경
        }
    }
}


