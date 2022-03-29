//
//  MyDrinkStampViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/29.
//

import Foundation
import RxSwift
import RxCocoa

final class MyDrinkStampViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let stamps: Driver<[Stamp]>
    }
    
    private let userUseCase: UserUseCase
    
    init(userUseCase: UserUseCase) {
        self.userUseCase = userUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let stamps = input.viewDidLoad
            .flatMap(userUseCase.fetchStamps)
            .map {
                result -> [Stamp] in
                guard case let .success(stamps) = result else { return [] }
                return stamps
            }
        
        return Output(
            stamps: stamps.asDriver(onErrorJustReturn: [])
        )
    }
}
