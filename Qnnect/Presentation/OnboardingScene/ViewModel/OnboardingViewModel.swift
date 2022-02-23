//
//  OnboardingViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/23.
//

import Foundation
import RxSwift
import RxCocoa


final class OnboardingViewModel: ViewModelType {
    
    struct Input {
        let didTapStartButton: Observable<Void>
    }
    
    struct Output {
        let showLoingScene: Signal<Void>
    }
    
    private weak var coordinator: SplashCoordinator?
    
    init(coordinator: SplashCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(from input: Input) -> Output {
        let showLoingScene = input.didTapStartButton
            .do(onNext: self.showLoginScene)
        
        return Output(showLoingScene: showLoingScene.asSignal(onErrorSignalWith: .empty()))
    }
}

private extension OnboardingViewModel {
    func showLoginScene() {
        self.coordinator?.showLogin()
    }
}

