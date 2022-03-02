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
    private let authUseCase: AuthUseCase
    
    init(
        coordinator: AuthCoordinator,
        authUseCase: AuthUseCase
    ) {
        self.coordinator = coordinator
        self.authUseCase = authUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        //TODO: 로그인 성공후 UserLoginInfo 에 있는 토큰 UserDefault에 저장
        //TODO: 기존회원일 경우 -> Main , 기존회원이지만 프로필 설정안했거나 새로운회원인 경우 -> Term
        let kakaoLogin = input.didTapKakaoButton
            .flatMap(self.socialLoginManager.kakaoLogin)
            .flatMap(self.kakaoLogin(_:))
            .compactMap(self.convertToUserLoginInfo)
            .map { ($0,LoginType.kakao) }
        
        let appleLogin = input.didTapAppleButton
            .flatMap(self.socialLoginManager.appleLogin)
            .flatMap(self.appleLogin(_:))
            .compactMap(self.convertToUserLoginInfo)
            .map { ($0,LoginType.apple) }
        
        let isSuccess = Observable.merge(kakaoLogin,appleLogin)
            .map { $0.0 }
            //.map(self.isExistedUser(_:))
            .do(onNext: self.showNextScene)
            .mapToVoid()
                
                
        return Output(
            showNextScene: isSuccess.asSignal(onErrorSignalWith: .empty())
        )
    }
}

private extension LoginViewModel {
    func kakaoLogin(_ accessToken: String) -> Observable<Result<UserLoginInfo,LoginError>> {
        return self.authUseCase.login(accessToken: accessToken, loginType: .kakao)
    }
    
    func appleLogin(_ accessToken: String) -> Observable<Result<UserLoginInfo,LoginError>> {
        return self.authUseCase.login(accessToken: accessToken, loginType: .apple)
    }
    
    func isExistedUser(_ userLoginInfo: UserLoginInfo) -> Bool {
        return (!userLoginInfo.isNewMember && userLoginInfo.userSettingDone)
    }
    
    func showNextScene(_ userLoginInfo: UserLoginInfo) {
        (userLoginInfo.isNewMember || !userLoginInfo.userSettingDone) ? self.showTermsScene() : self.showHomeScene()
    }
    
    func showHomeScene() {
        self.coordinator?.showMain()
    }
    
    func showTermsScene() {
        self.coordinator?.showTermsVC()
    }
    
    func convertToUserLoginInfo(_ result: Result<UserLoginInfo, LoginError>) -> UserLoginInfo? {
        guard case let .success(userLoginInfo) = result  else { return nil }
        return userLoginInfo
    }
    
}
