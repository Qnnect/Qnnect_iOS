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
        let showNextScene: Signal<Void>
    }
    
    var socialLoginManager: SocialLoginManager!
    private weak var coordinator: AuthCoordinator?
    private let loginUseCase: AuthUseCase
    
    init(
        coordinator: AuthCoordinator,
        loginUseCase: AuthUseCase
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
        
        let appleLogin = input.didTapAppleButton
            .flatMap(self.socialLoginManager.appleLogin)
            .flatMap(self.appleLogin(_:))

        
        let isSuccess = Observable.merge(kakaoLogin,appleLogin)
            .map(self.isExistedUser(_:))
            .do(onNext: self.showNextScene)
            .mapToVoid()
                
                
        return Output(
            showNextScene: isSuccess.asSignal(onErrorSignalWith: .empty())
        )
    }
}

private extension LoginViewModel {
    func kakaoLogin(_ accessToken: String) -> Observable<UserLoginInfo> {
        return self.loginUseCase.login(accessToken: accessToken, type: .kakao)
    }
    
    func appleLogin(_ accessToken: String) -> Observable<UserLoginInfo> {
        return self.loginUseCase.login(accessToken: accessToken, type: .apple)
    }
    
    func isExistedUser(_ userLoginInfo: UserLoginInfo) -> Bool {
        print((!userLoginInfo.isNewMember && userLoginInfo.userSettingDone))
        return (!userLoginInfo.isNewMember && userLoginInfo.userSettingDone)
    }
    
    func showNextScene(isExisted: Bool) {
        isExisted ? self.showHomeScene() : self.showTermsScene()
    }
    
    func showHomeScene() {
        self.coordinator?.showMain()
    }
    
    func showTermsScene() {
        print("call!!!")
        self.coordinator?.showTermsVC()
    }
}
