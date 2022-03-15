//
//  Rx+UIImageView.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/15.
//

import UIKit
import RxSwift

extension Reactive where Base: UIImageView {
    public var image: Observable<UIImage?> {
        base.rx.observe(UIImage.self, "image")
    }
}
