//
//  CafeModifyingViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/09.
//

import Foundation
import RxSwift
import RxCocoa

final class CafeModifyingViewModel: ViewModelType {
    struct Input {
        let selectedCycle: Observable<QuestionCycle>
        let inputName: Observable<String>
        let selectedGroupType: Observable<GroupType>
        let selectedDiaryColor: Observable<DiaryColorType>
        let didTapCompletionButton: Observable<Void>
        let cafeId: Observable<Int>
    }
    
    struct Output {
        let questionCycle: Driver<QuestionCycle>
        let isValidName: Signal<Bool>
        let isCompleted: Signal<Bool>
        let dismiss: Signal<Void>
    }
    
    private weak var coordinator: CafeCoordinator?
    private let cafeUseCase: CafeUseCase
    
    init(
        coordinator: CafeCoordinator,
        cafeUseCase: CafeUseCase
    ) {
        self.coordinator = coordinator
        self.cafeUseCase = cafeUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let questionCycle = input.selectedCycle
        
        let isValidName = input.inputName
            .map(self.cafeUseCase.isValidName(_:))
        
        let isCompleted = Observable.combineLatest(
            isValidName,
            input.selectedGroupType,
            input.selectedDiaryColor
        ).map {
            $0.0
        }
        
        let inputInfo = Observable.combineLatest(
            input.inputName,
            input.selectedGroupType,
            input.selectedDiaryColor,
            input.selectedCycle
        )
        
        let updateCafe = input.didTapCompletionButton
            .withLatestFrom(Observable.combineLatest(input.cafeId, inputInfo))
            .map { ($0.0, $0.1.0, $0.1.1, $0.1.2, $0.1.3)}
            .flatMap(self.cafeUseCase.updateCafe)
            .do {
                [weak self] _ in
                self?.coordinator?.dismiss()
            }
            .mapToVoid()
        
        return Output(
            questionCycle: questionCycle.asDriver(onErrorDriveWith: .empty()),
            isValidName: isValidName.asSignal(onErrorJustReturn: false),
            isCompleted: isCompleted.asSignal(onErrorJustReturn: false),
            dismiss: updateCafe.asSignal(onErrorSignalWith: .empty())
        )
    }
}
