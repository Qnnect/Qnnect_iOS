//
//  AddGroupViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/22.
//

import Foundation
import RxSwift
import RxCocoa

final class AddCafeViewModel: ViewModelType {
    
    struct Input {
        let selectedCycle: Observable<Int>
        let inputName: Observable<String>
        let selectedGroupType: Observable<GroupType>
        let selectedDiaryColor: Observable<String>
        let didTapNextButton: Observable<Void>
    }
    
    struct Output {
        let questionCycle: Driver<Int>
        let isValidName: Signal<Bool>
        let isCompleted: Signal<Bool>
        let showGroupScene: Signal<Void>
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
        
        let questionCycle = input.selectedCycle
        
        let isValidName = input.inputName
            .map(self.addGroupUseCase.isValidName(_:))
        
        let isCompleted = Observable.combineLatest(
            isValidName,
            input.selectedGroupType,
            input.selectedDiaryColor
        ).map {
            $0.0
        }
        
        let showGroupScene = input.didTapNextButton
            .do(onNext: self.showGroupScene)
        
        return Output(
            questionCycle: questionCycle.asDriver(onErrorJustReturn: 0),
            isValidName: isValidName.asSignal(onErrorJustReturn: false),
            isCompleted: isCompleted.asSignal(onErrorJustReturn: false),
            showGroupScene: showGroupScene.asSignal(onErrorSignalWith: .empty())
        )
    }
}

private extension AddCafeViewModel {
    func showGroupScene() {
        self.coordinator?.showGroupScene()
    }
}
