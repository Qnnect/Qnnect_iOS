//
//  LoginManager.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/10.
//

import Foundation
import RxKakaoSDKUser
import KakaoSDKUser
import RxSwift
import AuthenticationServices
import RxCocoa
import CryptoKit

protocol AuthManager {
    func kakaoLogin() -> Observable<Bool>
    func appleLogin() -> Observable<Bool>
}

final class DefaultAuthManager: NSObject, AuthManager {
    func kakaoLogin() -> Observable<Bool> {
    
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
        //authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
        return authorizationController.rx.authDelegate
    }
    
 
    
 
}

extension DefaultAuthManager: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print("login success")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            // Handle error.
            print("login error")
        }
}

class AuthManagerProxy: DelegateProxy<ASAuthorizationController, ASAuthorizationControllerDelegate>, DelegateProxyType, ASAuthorizationControllerDelegate {
    static func registerKnownImplementations() {
        self.register { (controller) -> AuthManagerProxy in
            AuthManagerProxy(parentObject: controller, delegateProxy: self)
        }
    }

    static func currentDelegate(for object: ASAuthorizationController) -> ASAuthorizationControllerDelegate? {
        return object.delegate
    }

    static func setCurrentDelegate(_ delegate: ASAuthorizationControllerDelegate?, to object: ASAuthorizationController) {
        object.delegate = delegate
    }
}


extension Reactive where Base: ASAuthorizationController {
    var delegate : DelegateProxy<ASAuthorizationController, ASAuthorizationControllerDelegate> {
        return AuthManagerProxy.proxy(for: self.base)
    }

    var authDelegate: Observable<Bool> {
        let success = delegate.methodInvoked(#selector(ASAuthorizationControllerDelegate.authorizationController(controller:didCompleteWithAuthorization:)))
            .debug("델리게이트 성공")
            .map { _ in return true }
        
        let fail = delegate.methodInvoked(#selector(ASAuthorizationControllerDelegate.authorizationController(controller:didCompleteWithError:)))
            .debug("델리게이트 성공 with error")
            .do(onNext: {
                print($0)
            })
            .map { _ in return false }
        return Observable.merge(success,fail)
                
                
    }
}
