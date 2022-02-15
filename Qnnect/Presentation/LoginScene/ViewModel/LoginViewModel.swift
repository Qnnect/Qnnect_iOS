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
    
    var loginManager: LoginManager!
    private weak var coordinator: LoginCoordinator?
    
    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(from input: Input) -> Output {
        let kakaoLogin = input.didTapKakaoButton
            .compactMap(self.loginManager.kakaoLogin)
            .flatMap{ $0 }
        
        let appleLogin = input.didTapAppleButton
            .compactMap(self.loginManager.appleLogin)
            .flatMap{ $0 }
        
        
        // TODO: 소셜 로그인 후 서버로 토큰을 전송해 기존에 존재해 있는 회원인지 확인 후 분기 처리
        let isSuccess = Observable.merge(kakaoLogin,appleLogin)
            .do(onNext :{ [weak self] isSuccess in
                if isSuccess {
                    self?.coordinator?.showInputNameVC()
                }
            })
                
        return Output(
            isSuccess: isSuccess.asSignal(onErrorJustReturn: false)
        )
    }
}
