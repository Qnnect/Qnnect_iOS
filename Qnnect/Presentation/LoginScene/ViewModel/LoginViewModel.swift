//
//  LoginViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/10.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel: ViewModelType {
    
    struct Input {
        let didTapKakaoButton: Observable<Void>
        let didTapAppleButton: Observable<Void>
    }
    
    struct Output {
        let isSuccess: Signal<Bool>
    }
    
    private let loginManager: LoginManager
    
    init(loginManager: LoginManager) {
        self.loginManager = loginManager
    }
    func transform(from input: Input) -> Output {
        let kakaoLogin = input.didTapKakaoButton
            .flatMap(self.loginManager.kakaoLogin)
        
        let appleLogin = input.didTapAppleButton
            .flatMap(self.loginManager.appleLogin)
        return Output(
            isSuccess: Observable.merge(kakaoLogin,appleLogin).asSignal(onErrorJustReturn: false)
        )
    }
}
