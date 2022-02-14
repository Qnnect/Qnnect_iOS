//
//  LoginManager.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/14.
//

import UIKit
import AuthenticationServices
import RxSwift
import RxKakaoSDKUser
import KakaoSDKUser
import RxCocoa

final class LoginManager: NSObject {
    private let vc: LoginViewController!
    
    init(vc: LoginViewController) {
        self.vc = vc
    }
    
    func kakaoLogin() -> Observable<Bool>{
        
        if (UserApi.isKakaoTalkLoginAvailable()) {
            return UserApi.shared.rx.loginWithKakaoTalk()
                .map{
                    token -> Bool in
                    //TODO: token 서버로 전송,로컬 저장
                    return true
                }.catchAndReturn(false)
            
        } else {
            return UserApi.shared.rx.loginWithKakaoAccount(prompts: [.Login])
                .map{
                    token -> Bool in
                    //TODO: token 서버로 전송,로컬 저장
                    return true
                }.catchAndReturn(false)
            
        }
    }
    
    func appleLogin() -> Observable<Bool> {
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.rx.delegate.setForwardToDelegate(self, retainDelegate: false)
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
        return authorizationController.rx.appleLoginSuccess
    }
}

extension LoginManager: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        //TODO: didCompleteWithAuthorization 후 동작
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //TODO: didCompleteWithError 후 동작
    }
}

extension LoginManager: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.vc.view.window ?? UIWindow()
    }
}

