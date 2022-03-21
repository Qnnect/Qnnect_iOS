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
        let selectedCycle: Observable<QuestionCycle>
        let inputName: Observable<String>
        let selectedGroupType: Observable<GroupType>
        let selectedDiaryColor: Observable<DiaryColorType>
        let didTapNextButton: Observable<Void>
    }
    
    struct Output {
        let questionCycle: Driver<QuestionCycle>
        let isValidName: Signal<Bool>
        let isCompleted: Signal<Bool>
        let showGroupScene: Signal<Int>
    }
    
    private let cafeUseCase: CafeUseCase
    
    init(cafeUseCase: CafeUseCase) {
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
        
        let createCafe = input.didTapNextButton
            .withLatestFrom(inputInfo)
            .flatMap(self.cafeUseCase.createRoom)
            .compactMap({ result -> Int? in
                guard case let .success(cafeId) = result else { return nil }
                return cafeId
            })
            
        
        return Output(
            questionCycle: questionCycle.asDriver(onErrorDriveWith: .empty()),
            isValidName: isValidName.asSignal(onErrorJustReturn: false),
            isCompleted: isCompleted.asSignal(onErrorJustReturn: false),
            showGroupScene: createCafe.asSignal(onErrorSignalWith: .empty())
        )
    }
}


