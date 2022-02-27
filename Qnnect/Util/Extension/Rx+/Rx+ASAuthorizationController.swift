//
//  ASAuthorizationController+.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/14.
//

import RxSwift
import RxCocoa
import AuthenticationServices

class LoginManagerProxy: DelegateProxy<ASAuthorizationController, ASAuthorizationControllerDelegate>, DelegateProxyType, ASAuthorizationControllerDelegate {
    static func registerKnownImplementations() {
        self.register { (controller) -> LoginManagerProxy in
            LoginManagerProxy(parentObject: controller, delegateProxy: self)
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
        return LoginManagerProxy.proxy(for: self.base)
    }
    
    var appleLoginSuccess: Observable<String> {
        let success = delegate.methodInvoked(#selector(ASAuthorizationControllerDelegate.authorizationController(controller:didCompleteWithAuthorization:)))
            .map {
                any -> String in
                let authorization = any[1] as? ASAuthorization
                
                if let credential = authorization?.credential as? ASAuthorizationAppleIDCredential {
                    let idToken = credential.identityToken!
                    let tokenStr = String(data: idToken, encoding: .ascii)
                    print(tokenStr ?? "")
                
                    guard let code = credential.authorizationCode else { return ""}
                    let codeStr = String(data: code, encoding: .utf8)
                    print(codeStr ?? "")
                    
                    let user = credential.user
                    print(user)
                    return tokenStr ?? ""
                }
                return ""
            }
        
        //        let fail = delegate.methodInvoked(#selector(ASAuthorizationControllerDelegate.authorizationController(controller:didCompleteWithError:)))
        //            .do(onNext: {
        //                print($0)
        //            })
        //            .map { _ in return false }
        
        return success
    }
}
