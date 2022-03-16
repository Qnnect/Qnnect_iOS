//
//  ModifyQuestionViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/16.
//

import Foundation
import RxSwift
import RxCocoa

final class ModifyQuestionViewModel: ViewModelType {
    
    struct Input {
        let question: Observable<Question>
        let didTapCompletionButton: Observable<Void>
        let content: Observable<String>
    }
    
    struct Output {
        let isEmpty: Driver<Bool>
        let completion: Signal<Void>
    }
    
    private let questionUseCase: QuestionUseCase
    
    init(questionUseCase: QuestionUseCase) {
        self.questionUseCase = questionUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let isEmpty = input.content
            .map { $0.count == 0 }
        
        let isContentEqualed = Observable.combineLatest(
            input.content,
            input.question.map { $0.content }
        ).map{ $0 == $1 }
        
        let modifing = input.didTapCompletionButton
            .withLatestFrom(isContentEqualed)
            .filter { !$0 }
            .withLatestFrom(
                Observable.combineLatest(
                    input.question.map{ $0.id },
                    input.content,
                    resultSelector: {
                        (questionId: $0, content: $1)
                    })
            ).flatMap(questionUseCase.modifyQuestion)
            .compactMap { result -> Void? in
                guard case .success(_) = result else { return nil }
                return Void()
            }
        
        let completion = Observable.merge(
            modifing.mapToVoid(),
            input.didTapCompletionButton
                .withLatestFrom(isContentEqualed)
                .filter { $0 }
                .mapToVoid()
        )
        
        return Output(
            isEmpty: isEmpty.asDriver(onErrorDriveWith: .empty()),
            completion: completion.asSignal(onErrorSignalWith: .empty())
        )
    }
}
