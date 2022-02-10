//
//  Observable+.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/10.
//

import Foundation
import RxSwift


public extension ObservableType {
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}

