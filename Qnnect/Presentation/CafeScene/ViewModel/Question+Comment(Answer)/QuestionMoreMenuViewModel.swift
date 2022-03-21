//
//  QuestionMoreMenuViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/22.
//

import Foundation
import RxSwift
import RxCocoa

final class QuestionMoreMenuViewModel: ViewModelType {
    
    struct Input {
        let question: Observable<Question>
        let didTapModifyButton: Observable<Void>
        let didTapDeleteButton: Observable<Void>
        let didTapDeleteAlertOkButton: Observable<Void>
    }
    
    struct Output {
        let showDeleteAlertView: Signal<Void>
        let delete: Signal<Void>
        let showModeifyQuestionScene: Signal<Question>
    }
    
    private let questionUseCase: QuestionUseCase
    
    init(questionUseCase: QuestionUseCase) {
        self.questionUseCase = questionUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let showDeleteAlertView = input.didTapDeleteButton
        
        //TODO: 에러든 성공이든 화면전환을 위해 mapToVoid 나중에 에러처리 필요
        let deleteQuestion = input.didTapDeleteAlertOkButton
            .withLatestFrom(input.question.map { $0.id} )
            .flatMap(questionUseCase.deleteQuestion(_:))
            .mapToVoid()
        
        let showModifyQuestionScene = input.didTapModifyButton
            .withLatestFrom(input.question)
        
        return Output(
            showDeleteAlertView: showDeleteAlertView.asSignal(onErrorSignalWith: .empty()),
            delete: deleteQuestion.asSignal(onErrorSignalWith: .empty()),
            showModeifyQuestionScene: showModifyQuestionScene.asSignal(onErrorSignalWith: .empty())
        )
    }
}
