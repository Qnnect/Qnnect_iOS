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

    var appleLoginSuccess: Observable<Bool> {
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
