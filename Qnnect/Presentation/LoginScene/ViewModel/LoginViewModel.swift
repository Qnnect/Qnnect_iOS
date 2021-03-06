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
        let inviteCode: Observable<String>
    }
    
    struct Output {
        let showTermsScene: Signal<(token: Token, loginType: LoginType)>
        let showHomeScene: Signal<Void>
        let inviteFlowTermScene: Signal<(Token, LoginType, String)>
        let inviteFlowHomeScene: Signal<String>
        let loginError: Signal<Void>
        let storeDeviceToken: Signal<Void>
    }
    
    var socialLoginManager: SocialLoginManager!
    private let authUseCase: AuthUseCase
    private let notificationUseCase: NotificationUseCase
    
    init(
        authUseCase: AuthUseCase,
        notificationUseCase: NotificationUseCase
    ) {
        self.authUseCase = authUseCase
        self.notificationUseCase = notificationUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        //TODO: 로그인 성공후 UserLoginInfo 에 있는 토큰 UserDefault에 저장
        //TODO: 기존회원일 경우 -> Main , 기존회원이지만 프로필 설정안했거나 새로운회원인 경우 -> Term
        let kakaoLogin = input.didTapKakaoButton
            .flatMap(self.socialLoginManager.kakaoLogin)
            .compactMap({ result -> String? in
                guard case let .success(token) = result else { return nil }
                return token
            })
            .flatMap(self.kakaoLogin(_:))
            .share()
        
        let appleLogin = input.didTapAppleButton
            .flatMap(self.socialLoginManager.appleLogin)
            .flatMap(self.appleLogin(_:))
            .share()
            .debug()
        
        let kakaoLoginSuccess = kakaoLogin.compactMap(self.convertToUserLoginInfo)
            .map { ($0,LoginType.kakao) }
        
        let appleLoginSucess = appleLogin.compactMap(convertToUserLoginInfo(_:))
            .map{ ($0, LoginType.apple) }
            .debug()
        
        let loginError = Observable.merge(
            kakaoLogin.compactMap(convertToError(_:)),
            appleLogin.compactMap(convertToError(_:))
        ).mapToVoid()
        
        let isSuccess = Observable.merge(kakaoLoginSuccess, appleLoginSucess)
            .do{
                [weak self] userLoginInfo,loginType in
                if !userLoginInfo.isNewMember, userLoginInfo.userSettingDone {
                    self?.authUseCase.saveToken(access: userLoginInfo.accessToken, refresh: userLoginInfo.refreshToken)
                    self?.authUseCase.saveLoginType(loginType)
                    self?.authUseCase.updateFirstAccess()
                }
            }
            .debug()
            .share()
        
        let storeDeviceToken = isSuccess.mapToVoid()
            .flatMap(notificationUseCase.storeDeviceToken)
            .mapToVoid()
        
        let showTermsScene = isSuccess.filter(isNeedToSetting)
            .map {
                userLoginInfo, type -> (token: Token, loginType: LoginType) in
                let token = Token(access: userLoginInfo.accessToken, refresh: userLoginInfo.refreshToken)
                return (token, type)
            }
        
        let inviteFlowTermsScene = isSuccess.filter(isNeedToSetting)
            .map {
                userLoginInfo, type -> (token: Token, loginType: LoginType) in
                let token = Token(access: userLoginInfo.accessToken, refresh: userLoginInfo.refreshToken)
                return (token, type)
            }
            .withLatestFrom(input.inviteCode , resultSelector: { ($0.0, $0.1, $1) })
        
        let showHomeScene = isSuccess
            .take(until: input.inviteCode)
            .filter{
                [weak self] in
                self?.isNeedToSetting($0, $1) == false
            }.mapToVoid()
        
        let inviteFlowHomeScene = isSuccess
            .filter{
                [weak self] in
                self?.isNeedToSetting($0, $1) == false
            }.withLatestFrom(input.inviteCode)
        
        return Output(
            showTermsScene: showTermsScene.asSignal(onErrorSignalWith: .empty()),
            showHomeScene: showHomeScene.asSignal(onErrorSignalWith: .empty()),
            inviteFlowTermScene: inviteFlowTermsScene.asSignal(onErrorSignalWith: .empty()),
            inviteFlowHomeScene: inviteFlowHomeScene.asSignal(onErrorSignalWith: .empty()),
            loginError: loginError.asSignal(onErrorSignalWith: .empty()),
            storeDeviceToken: storeDeviceToken.asSignal(onErrorSignalWith: .empty())
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
    
    func convertToError(_ result: Result<UserLoginInfo, LoginError>) -> Error? {
        guard case let .failure(error) = result else { return nil }
        return error
    }
    
}
