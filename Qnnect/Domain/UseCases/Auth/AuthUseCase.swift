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
    func login(accessToken: String, type: LoginType) -> Observable<UserLoginInfo>
    func saveToken(access: String, refresh: String, type: LoginType)
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
    
    func login(accessToken: String, type: LoginType) -> Observable<UserLoginInfo> {
        return self.authRepository.login(accessToken: accessToken, type: type)
    }
    
    func saveToken(access: String, refresh: String, type: LoginType) {
        let token = Token(
            access: access,
            refresh: refresh,
            type: type
        )
        return self.authRepository.saveToken(token: token)
    }
}
