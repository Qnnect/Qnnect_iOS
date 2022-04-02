//
//  WaitingQuestionBottomSheetViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/04/02.
//

import Foundation
import RxSwift
import RxCocoa

final class WaitingQuestionBottomSheetViewModel: ViewModelType {
    
    struct Input {
        let question: Observable<UserQuestion>
        let didTapModifyButton: Observable<Void>
        let didTapDeleteButton: Observable<Void>
        let didTapDeleteAlertOkButton: Observable<Void>
    }
    
    struct Output {
        let showModifyQuestionScene: Signal<UserQuestion>
        let showDeleteAlertView: Signal<Void>
        let delete: Signal<Void>
    }
    
    private let questionUseCase: QuestionUseCase
    
    init(questionUseCase: QuestionUseCase) {
        self.questionUseCase = questionUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let showModifyQuestionScene = input.didTapModifyButton
            .withLatestFrom(input.question)
        
        let showDeleteAlertView = input.didTapDeleteButton
        
        let delete = input.didTapDeleteAlertOkButton
            .withLatestFrom(input.question.map { $0.id })
            .flatMap(questionUseCase.deleteUserQuestion(_:))
            .compactMap { result -> Void? in
                guard case .success(_) = result else { return nil }
                return Void()
            }
        
        return Output(
            showModifyQuestionScene: showModifyQuestionScene.asSignal(onErrorSignalWith: .empty()),
            showDeleteAlertView: showDeleteAlertView.asSignal(onErrorSignalWith: .empty()),
            delete: delete.asSignal(onErrorSignalWith: .empty())
        )
    }
}
