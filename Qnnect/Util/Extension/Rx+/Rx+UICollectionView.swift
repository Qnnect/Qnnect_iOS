//
//  File.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/17.
//

import RxSwift
import UIKit
import RxCocoa

extension Reactive where Base: UICollectionView {
    public func modelAndIndexSelected<T>(_ modelType: T.Type) -> ControlEvent<(T, IndexPath)> {
        ControlEvent(events: Observable.zip(
            self.modelSelected(modelType),
            self.itemSelected
        ))
    }
}
