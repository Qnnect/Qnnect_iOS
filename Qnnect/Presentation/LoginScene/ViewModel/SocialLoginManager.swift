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

final class SocialLoginManager: NSObject {
    private let vc: UIViewController!
    
    init(vc: UIViewController) {
        self.vc = vc
    }
    
    func kakaoLogin() -> Observable<String>{
        
        if (UserApi.isKakaoTalkLoginAvailable()) {
            return UserApi.shared.rx.loginWithKakaoTalk()
                .map { $0.accessToken }
            
        } else {
            return UserApi.shared.rx.loginWithKakaoAccount(prompts: [.Login])
                .map{ $0.accessToken }
                .debug()
        }
    }
    
    func getUserProfileImageInKakao() -> Observable<URL?> {
        return UserApi.shared.rx.me()
            .asObservable()
            .map { $0.kakaoAccount?.profile?.profileImageUrl }
    }
    
    func appleLogin() -> Observable<String> {
        
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

extension SocialLoginManager: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        //TODO: didCompleteWithAuthorization 후 동작
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let idToken = credential.identityToken!
            let tokenStr = String(data: idToken, encoding: .utf8)
            print(tokenStr ?? "apple token nil")
            
            guard let code = credential.authorizationCode else { return }
            let codeStr = String(data: code, encoding: .utf8)
            print(codeStr ?? "apple authorizationCode nil")
            
            let user = credential.user
            print(user)
            
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //TODO: didCompleteWithError 후 동작
    }
}

extension SocialLoginManager: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.vc.view.window ?? UIWindow()
    }
}

