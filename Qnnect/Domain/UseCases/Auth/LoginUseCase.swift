//
//  LoginUseCase.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/23.
//

import Foundation
import RxSwift
import RxCocoa

protocol LoginUseCase: AnyObject {
    func fetchIsFirstAccess() -> Bool
    func fetchToken() -> (access: String, refresh: String, type: LoginType)?
    func login(accessToken: String, type: LoginType) -> Observable<UserLoginInfo>
}

final class DefaultLoginUseCase: LoginUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func fetchIsFirstAccess() -> Bool {
        return self.authRepository.fetchIsFirstAccess()
    }
    
    func fetchToken() -> (access: String, refresh: String, type: LoginType)? {
        self.authRepository.fetchToken()
    }
    
    func login(accessToken: String, type: LoginType) -> Observable<UserLoginInfo> {
        self.authRepository.login(accessToken: accessToken, type: type)
    }
}
