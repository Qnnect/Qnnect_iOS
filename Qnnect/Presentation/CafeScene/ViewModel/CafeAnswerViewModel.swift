//
//  CafeAnswerViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/08.
//

import Foundation
import RxSwift
import RxCocoa

final class CafeAnswerViewModel: ViewModelType {
    
    struct Input {
        let didTapAnswerWritingCell: Observable<Void>
        let question: Observable<Question>
        let user: Observable<User>
    }
    
    struct Output {
        let showAnswerWritingScene: Signal<Void>
    }
    
    private weak var coordinator: CafeCoordinator?
    
    init(coordinator: CafeCoordinator) {
        self.coordinator = coordinator
    }
    func transform(from input: Input) -> Output {
        
        let showAnswerWritingScene = input.didTapAnswerWritingCell
            .withLatestFrom(Observable.combineLatest(input.question, input.user))
            .do {
                [weak self] question, user in
                self?.coordinator?.showCafeAnswerWritingScene(question, user)
            }
            .mapToVoid()
        
        return Output(
            showAnswerWritingScene: showAnswerWritingScene.asSignal(onErrorSignalWith: .empty())
        )
    }
}
