//
//  NotificationListViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/22.
//

import Foundation
import RxSwift
import RxCocoa

final class NotificationListViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad: Observable<Void>
        
    }
    
    struct Output {
        let notis: Driver<Void>
    }
    
    func transform(from input: Input) -> Output {
        return Output(
            notis: input.viewDidLoad.asDriver(onErrorDriveWith: .empty())
        )
    }
}
