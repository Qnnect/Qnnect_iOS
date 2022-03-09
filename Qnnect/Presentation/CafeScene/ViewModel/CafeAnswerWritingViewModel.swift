//
//  CafeAnswerWritingViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/09.
//

import Foundation
import RxSwift
import RxCocoa

final class CafeAnswerWritingViewModel: ViewModelType {
    
    struct Input {
        let inputText: Observable<String>
    }
    
    struct Output {
        let isInputCompleted: Driver<Bool>
    }
    
    private weak var coordinator: CafeCoordinator?
    
    init(coordinator: CafeCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(from input: Input) -> Output {
        
        let isInputCompleted = input.inputText
            .map { $0.count >= 10 }
        
        return Output(
            isInputCompleted: isInputCompleted.asDriver(onErrorJustReturn: false)
        )
    }
}
