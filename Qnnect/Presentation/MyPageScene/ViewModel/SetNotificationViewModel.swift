//
//  SetNotificationViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/04/03.
//

import Foundation
import RxCocoa
import RxSwift

final class SetNotificationViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let toggle: Observable<Bool>
    }
    
    struct Output {
        let isOn: Driver<Bool>
        let setEnableNotification: Signal<Void>
    }
    
    private let userUseCase: UserUseCase
    
    init(userUseCase: UserUseCase) {
        self.userUseCase = userUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let isOn = input.viewDidLoad
            .flatMap(userUseCase.fetchIsEnableNotification)
            .compactMap { result -> Bool? in
                guard case let .success(isOn) = result else { return nil }
                return isOn
            }
        
        let setEnableNotification = input.toggle
            .flatMap(userUseCase.setEnableNotification(isAgreedNoti:))
            
        
        return Output(
            isOn: isOn.asDriver(onErrorJustReturn: false),
            setEnableNotification: setEnableNotification.asSignal(onErrorSignalWith: .empty())
        )
    }
}
