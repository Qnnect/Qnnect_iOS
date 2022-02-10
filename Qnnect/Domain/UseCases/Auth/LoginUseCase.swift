//
//  Login.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/10.
//

import Foundation
import RxSwift

protocol LoginUseCase: AnyObject {
    func kakaoLogin() -> Observable<Bool>
    func appleLogin()
}

final class DefaultLoginUseCase: LoginUseCase {
    private let authManager: AuthManager
    
    init(authManager: AuthManager) {
        self.authManager = authManager
    }
    func kakaoLogin() -> Observable<Bool> {
        return self.authManager.kakaoLogin()
    }
    
    func appleLogin() {
        
    }
}
