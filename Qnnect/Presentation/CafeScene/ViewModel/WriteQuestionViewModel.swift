//
//  WriteQuestionViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/13.
//

import Foundation
import RxSwift
import RxCocoa

final class WriteQuestionViewModel: ViewModelType {
    
    struct Input {
        let content: Observable<String>
        let didTapCompletionButton: Observable<Void>
        let cafeId: Observable<Int>
    }
    
    struct Output {
        let isCompleted: Driver<Bool>
        let completion: Signal<Void>
    }
    
    private let cafeUseCase: CafeUseCase
    
    init(cafeUseCase: CafeUseCase) {
        self.cafeUseCase = cafeUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let isCompleted = input.content
            .map { $0.count >= 10 }
        
        let completion = input.didTapCompletionButton
            .withLatestFrom(Observable.combineLatest(input.cafeId,input.content))
            .flatMap(cafeUseCase.createQuestion)
            .compactMap {
                result -> Void? in
                guard case .success() = result else { return nil }
                return Void()
            }

        
        return Output(
            isCompleted: isCompleted.asDriver(onErrorJustReturn: false),
            completion: completion.asSignal(onErrorSignalWith: .empty())
        )
    }
}
