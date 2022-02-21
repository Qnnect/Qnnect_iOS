//
//  ViewModelType.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/06.
//

import Foundation
import RxSwift

protocol ViewModelType: AnyObject {
    associatedtype Input
    associatedtype Output
    
    func transform(from input: Input) -> Output
}
