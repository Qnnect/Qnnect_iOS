//
//  QuestionCompletionAlertViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/16.
//

import Foundation
import RxSwift
import RxCocoa

final class QuestionCompletionAlertViewModel: ViewModelType {
    
    struct Input{
        let didTapGoCafeRoomButton: Observable<Void>
        let didTapGoMyQuestionButton: Observable<Void>
    }
    
    struct Output {
        let showCafeRoomScene: Signal<QuestionCompletionBehaviorType>
        let showMyQustionScene: Signal<QuestionCompletionBehaviorType>
    }
    
    func transform(from input: Input) -> Output {
        return Output(
            showCafeRoomScene: input.didTapGoCafeRoomButton
                .map{ QuestionCompletionBehaviorType.goCafe }
                .asSignal(onErrorSignalWith: .empty()),
            showMyQustionScene: input.didTapGoMyQuestionButton
                .map { QuestionCompletionBehaviorType.goMyQuestion }
                .asSignal(onErrorSignalWith: .empty())
        )
    }
}
