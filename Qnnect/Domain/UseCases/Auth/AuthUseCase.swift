//
//  LoginUseCase.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/23.
//

import Foundation
import RxSwift
import RxCocoa

protocol AuthUseCase: AnyObject {
    func fetchIsFirstAccess() -> Bool
    func fetchToken() -> Token?
    func login(accessToken: String, loginType: LoginType) -> Observable<Result<UserLoginInfo,LoginError>>
    func saveToken(access: String, refresh: String, loginType: LoginType)
}

final class DefaultAuthUseCase: AuthUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func fetchIsFirstAccess() -> Bool {
        return self.authRepository.fetchIsFirstAccess()
    }
    
    func fetchToken() -> Token? {
        return self.authRepository.fetchToken()
    }
    
    func login(accessToken: String, loginType: LoginType) -> Observable<Result<UserLoginInfo,LoginError>> {
        return self.authRepository.login(accessToken: accessToken, type: loginType)
    }
    
    func saveToken(access: String, refresh: String, loginType: LoginType) {
        let token = Token(
            access: access,
            refresh: refresh,
            loginType: loginType
        )
        return self.authRepository.saveToken(token: token)
    }
}
