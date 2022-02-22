//
//  AddGroupViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/22.
//

import Foundation
import RxSwift
import RxCocoa

final class AddGroupViewModel: ViewModelType {
    
    struct Input {
        let sliderValue: Observable<Float>
    }
    
    struct Output {
        let questionCycle: Driver<Int>
    }
    
    private weak var coordinator: HomeCoordinator?
    private let addGroupUseCase: AddGroupUseCase
    init(
        coordinator:HomeCoordinator,
        addGroupUseCase: AddGroupUseCase
    ) {
        self.coordinator = coordinator
        self.addGroupUseCase = addGroupUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let questionCycle = input.sliderValue
            .map(self.addGroupUseCase.adjustQuestionCycle(_:))
        
        return Output(
            questionCycle: questionCycle.asDriver(onErrorJustReturn: 0)
        )
    }
}

