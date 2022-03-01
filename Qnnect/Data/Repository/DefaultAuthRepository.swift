//
//  AuthRepository.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/23.
//

import Foundation
import RxSwift
import RxCocoa

final class DefaultAuthRepository: AuthRepository {
    
    private let localStorage: UserDefaultManager
    private let authNetworkService: AuthNetworkService
    
    init(
        localStorage: UserDefaultManager,
        authNetworkService: AuthNetworkService
    ) {
        self.localStorage = localStorage
        self.authNetworkService = authNetworkService
    }
    
    func fetchIsFirstAccess() -> Bool {
        return self.localStorage.isFirstAccess ?? true
    }
    
    func fetchToken() -> Token? {
        return self.localStorage.token
    }
    
    func login(accessToken: String, type: LoginType) -> Observable<UserLoginInfo> {
        let request = LoginRequestDTO(accessToken: accessToken, loginType: type)
        return self.authNetworkService.login(request: request).map { $0.toDomain() }
    }
    
    func saveToken(token: Token) {
        localStorage.token = token
        if let token = localStorage.token {
            print("token save success 😎!!!: \(token)")
        }
    }
    
}
