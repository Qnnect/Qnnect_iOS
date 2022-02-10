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
    
    private let loginUseCase: LoginUseCase
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
    func transform(from input: Input) -> Output {
        let kakaoLogin = input.didTapKakaoButton
            .flatMap(self.loginUseCase.kakaoLogin)
        
        return Output(
            isSuccess: kakaoLogin.asSignal(onErrorJustReturn: false)
        )
    }
}
