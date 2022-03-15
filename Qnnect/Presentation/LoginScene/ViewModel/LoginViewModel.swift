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
        let showTermsScene: Signal<(token: Token, loginType: LoginType)>
        let showHomeScene: Signal<Void>
    }
    
    var socialLoginManager: SocialLoginManager!
    private let authUseCase: AuthUseCase
    
    init(authUseCase: AuthUseCase) {
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
            .do{
                [weak self] userLoginInfo,loginType in
                if !userLoginInfo.isNewMember, userLoginInfo.userSettingDone {
                    self?.authUseCase.saveToken(access: userLoginInfo.accessToken, refresh: userLoginInfo.refreshToken)
                    self?.authUseCase.saveLoginType(loginType)
                }
            }
            .share()
        
        let showTermsScene = isSuccess.filter(isNeedToSetting)
            .map {
                userLoginInfo, type -> (token: Token, loginType: LoginType) in
                let token = Token(access: userLoginInfo.accessToken, refresh: userLoginInfo.refreshToken)
                return (token, type)
            }
        
        let showHomeScene = isSuccess.filter{
            [weak self] in
            self?.isNeedToSetting($0, $1) == false
        }.mapToVoid()
        
        return Output(
            showTermsScene: showTermsScene.asSignal(onErrorSignalWith: .empty()),
            showHomeScene: showHomeScene.asSignal(onErrorSignalWith: .empty())
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
    
    func isNeedToSetting(_ userLoginInfo: UserLoginInfo, _ loginType: LoginType) -> Bool {
        return (userLoginInfo.isNewMember || !userLoginInfo.userSettingDone)
    }
    
    func convertToUserLoginInfo(_ result: Result<UserLoginInfo, LoginError>) -> UserLoginInfo? {
        guard case let .success(userLoginInfo) = result  else { return nil }
        return userLoginInfo
    }
    
}
