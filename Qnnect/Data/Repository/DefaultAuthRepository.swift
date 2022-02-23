//
//  AuthRepository.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/23.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

final class DefaultAuthRepository: AuthRepository {
    
    private let localStorage: UserDefaultManager
    private let authNetworkManager: AuthNetworkManager
    
    init(
        localStorage: UserDefaultManager,
        authNetworkManager: AuthNetworkManager
    ) {
        self.localStorage = localStorage
        self.authNetworkManager = authNetworkManager
    }
    
    func fetchIsFirstAccess() -> Bool {
        return self.localStorage.isFirstAccess ?? true
    }
    
    func fetchToken() -> (access: String, refresh: String, type: LoginType)? {
        return self.localStorage.token
    }
    
    func login(accessToken: String, type: LoginType) -> Observable<UserLoginInfo> {
        let request = LoginRequestDTO(accessToken: accessToken, loginType: type)
        return self.authNetworkManager.login(request: request).map { $0.toDomain() }
    }
}
