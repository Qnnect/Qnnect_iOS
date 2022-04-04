//
//  ModifyWaitingQuestionViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/04/02.
//

import Foundation
import RxSwift
import RxCocoa

final class ModifyWaitingQuestionViewModel: ViewModelType {
    
    struct Input {
        let question: Observable<UserQuestion>
        let didTapCompletionButton: Observable<Void>
        let content: Observable<String>
    }
    
    struct Output {
        let isCompleted: Driver<Bool>
        let completion: Signal<String>
    }
    
    private let questionUseCase: QuestionUseCase
    
    init(questionUseCase: QuestionUseCase) {
        self.questionUseCase = questionUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let isCompleted = input.content
            .map { $0.count >= 10 }
        
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
            ).flatMap(questionUseCase.modifyUserQuestion)
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
        ).withLatestFrom(input.content)
        
        return Output(
            isCompleted: isCompleted.asDriver(onErrorDriveWith: .empty()),
            completion: completion.asSignal(onErrorSignalWith: .empty())
        )
    }
}
