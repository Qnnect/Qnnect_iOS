//
//  LoginUseCase.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/23.
//

import Foundation
import RxSwift
import RxCocoa

protocol AuthUseCase: InputUseCase {
    func fetchIsFirstAccess() -> Bool
    func fetchToken() -> Token?
    func login(accessToken: String, loginType: LoginType) -> Observable<Result<UserLoginInfo,LoginError>>
    func saveToken(access: String, refresh: String)
    func reissueToken(token: Token) -> Observable<Result<Token, Error>>
    func updateFirstAccess()
    func saveLoginType(_ type: LoginType)
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
    
    func saveToken(access: String, refresh: String) {
        return self.authRepository.saveToken(access: access, refresh: refresh)
    }
    
    func reissueToken(token: Token) -> Observable<Result<Token, Error>> {
        return self.authRepository.reissueToken(token: token)
            .do(onNext: {
                [weak self] result in
                guard case let .success(token) = result else { return }
                self?.saveToken(access: token.access, refresh: token.refresh)
            })
    }
    
    func updateFirstAccess() {
        return self.authRepository.updateFirstAccess()
    }
    
    func saveLoginType(_ type: LoginType) {
        self.authRepository.saveLoginType(type)
    }
}
