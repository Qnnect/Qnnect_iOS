//
//  WaitingQuestionViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/04/02.
//

import Foundation
import RxSwift
import RxCocoa

final class WaitingQuestionViewModel: ViewModelType {
    
    struct Input {
        let question: Observable<UserQuestion>
        let didTapMoreButton: Observable<Void>
    }
    
    struct Output {
        let showMoreMenu: Signal<UserQuestion>
    }
    
    func transform(from input: Input) -> Output {
        
        let showMoreMenu = input.didTapMoreButton
            .withLatestFrom(input.question)
        
        return Output(
            showMoreMenu: showMoreMenu.asSignal(onErrorSignalWith: .empty())
        )
    }
}
