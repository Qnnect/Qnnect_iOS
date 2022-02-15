//
//  TermsViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/14.
//

import Foundation
import RxSwift
import RxCocoa

final class TermsViewModel: ViewModelType {
    
    struct Input {
        let didTapStartButton: Observable<Void>
    }
    
    struct Output {
        let start: Signal<Void>
    }
    
    private weak var coordinator: LoginCoordinator?
    
    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(from input: Input) -> Output {
        let start = input.didTapStartButton
            .do(onNext: {
                [weak self] _ in
                self?.coordinator?.showHomeVC()
            })
        return Output(
            start: start.asSignal(onErrorJustReturn: ())
        )
    }
}
