//
//  SplashViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/23.
//

import Foundation
import RxSwift
import RxCocoa

final class SplashViewModel: ViewModelType {
    
    struct Input {
        let didEndSplash: Observable<Void>
    }
    
    struct Output {
        let showOnboarding: Signal<Void>
        let showLogin: Signal<Void>
        let showMain: Signal<Void>
    }
    
    private weak var coordinator: SplashCoordinator?
    private let loginUseCase: AuthUseCase
    
    init(
        coordinator: SplashCoordinator,
        loginUseCase: AuthUseCase
    ) {
        self.coordinator = coordinator
        self.loginUseCase = loginUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let firstAccess = input.didEndSplash
            .map(self.loginUseCase.fetchIsFirstAccess)
            .filter{ $0 }
            .mapToVoid()
            .do(onNext: self.showOnboardingScene)
        
        //TODO: 가져온 토큰으로 로그인 진행 후 프로필 설정 못했으면 프로필설정화면 으로 분기처리해야함
        let autoLogin = input.didEndSplash
            .map(self.loginUseCase.fetchToken)
            .compactMap { $0 }
            .filter{ $0.type == .kakao } //현재 카카오 로그인 만 된다.
            .mapToVoid()
        
        let needToLogin = input.didEndSplash
            .map(self.loginUseCase.fetchToken)
            .filter { $0 == nil }
            .mapToVoid()
        
        return Output(
            showOnboarding: firstAccess.asSignal(onErrorSignalWith: .empty()),
            showLogin: needToLogin.asSignal(onErrorSignalWith: .empty()),
            showMain: autoLogin.asSignal(onErrorSignalWith: .empty())
        )
    }
    
}


private extension SplashViewModel {
    func showOnboardingScene() {
        self.coordinator?.showOnboarding()
    }
}
