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
    func saveToken(token: Token)
    func reissueToken(token: Token) -> Observable<Result<Token, Error>>
    func updateFirstAccess()
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
    
    func saveToken(token: Token) {
        return self.authRepository.saveToken(token: token)
    }
    
    func reissueToken(token: Token) -> Observable<Result<Token, Error>> {
        return self.authRepository.reissueToken(token: token)
            .do(onNext: {
                [weak self] result in
                guard case let .success(token) = result else { return }
                self?.saveToken(token: token)
            })
    }
    
    func updateFirstAccess() {
        return self.authRepository.updateFirstAccess()
    }
}
