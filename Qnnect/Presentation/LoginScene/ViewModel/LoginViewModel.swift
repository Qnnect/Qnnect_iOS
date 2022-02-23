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
        let showHomeScene: Signal<Void>
       // let showTermsScene: Signal<Void>
    }
    
    var socialLoginManager: SocialLoginManager!
    private weak var coordinator: AuthCoordinator?
    private let loginUseCase: LoginUseCase
    
    init(
        coordinator: AuthCoordinator,
        loginUseCase: LoginUseCase
    ) {
        self.coordinator = coordinator
        self.loginUseCase = loginUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        //TODO: 로그인 성공후 UserLoginInfo 에 있는 토큰 UserDefault에 저장
        //TODO: 기존회원일 경우 -> Main , 기존회원이지만 프로필 설정안했거나 새로운회원인 경우 -> Term
        let kakaoLogin = input.didTapKakaoButton
            .flatMap(self.socialLoginManager.kakaoLogin)
            .flatMap(self.kakaoLogin(_:))
            .do(onNext: {
                print("test\($0)")
            })
                let a = kakaoLogin
            .map(self.isExistedUser(_:))
                .do(onNext: {
                    [weak self] in
                    $0 ? self?.showHomeScene() : self?.showTermsScene()
                })
                .mapToVoid()
        
    
                
//        let appleLoginSuccess = input.didTapAppleButton
//            .compactMap(self.authManager.appleLogin)
//            .flatMap{ $0 }
//            .filter{ $0 }
//            .mapToVoid()
                
        return Output(
            showHomeScene: a.asSignal(onErrorSignalWith: .empty())
           // showTermsScene: notSetedUser.asSignal(onErrorSignalWith: .empty())
        )
    }
}

private extension LoginViewModel {
    func kakaoLogin(_ accessToken: String) -> Observable<UserLoginInfo> {
        return self.loginUseCase.login(accessToken: accessToken, type: .kakao)
    }
    
    func isExistedUser(_ userLoginInfo: UserLoginInfo) -> Bool {
        print((!userLoginInfo.isNewMember && userLoginInfo.userSettingDone))
        return (!userLoginInfo.isNewMember && userLoginInfo.userSettingDone)
    }
    
    func showHomeScene() {
        self.coordinator?.showMain()
    }
    
    func showTermsScene() {
        print("call!!!")
        self.coordinator?.showTermsVC()
    }
}
