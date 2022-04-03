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
    private let versionNetworkService: VersionNetworkService
    
    init(
        localStorage: UserDefaultManager,
        authNetworkService: AuthNetworkService,
        versionNetworkService: VersionNetworkService
    ) {
        self.localStorage = localStorage
        self.authNetworkService = authNetworkService
        self.versionNetworkService = versionNetworkService
    }
    
    func fetchIsFirstAccess() -> Bool {
        return self.localStorage.isFirstAccess ?? true
    }
    
    func fetchToken() -> Token? {
        guard let accessToken = KeyChain.read(key: Constants.accessTokenKey),
              let refreshToken = KeyChain.read(key: Constants.refreshTokenKey)
        else { return nil }
        
        return Token(access: accessToken, refresh: refreshToken)
    }
    
    func login(accessToken: String, type: LoginType) -> Observable<Result<UserLoginInfo, LoginError>> {
        let request = LoginRequestDTO(accessToken: accessToken, loginType: type)
        return self.authNetworkService.login(request: request)
            .map {
                result in
                switch result {
                case .success(let loginResponseDTO):
                    return .success(loginResponseDTO.toDomain())
                case .failure(let loginError):
                    return .failure(loginError)
                }
            }
    }
    
    func saveToken(access: String, refresh: String) {
        KeyChain.create(key: Constants.accessTokenKey, token: access)
        KeyChain.create(key: Constants.refreshTokenKey, token: refresh)
        if let accessToken = KeyChain.read(key: Constants.accessTokenKey),
           let refreshToken = KeyChain.read(key: Constants.refreshTokenKey) {
            print("token save success 😎  access: \(accessToken), refresh: \(refreshToken)")
        }
    }
    
    func reissueToken(token: Token) -> Observable<Result<Token, Error>> {
        let request = ReissueRequestDTO(
            accessToken: token.access,
            refreshToken: token.refresh
        )
        return self.authNetworkService.reissueToken(request: request)
            .map{
                result -> Result<Token,Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.toDomain())
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
    func updateFirstAccess() {
        self.localStorage.isFirstAccess = false
    }
    
    func saveLoginType(_ type: LoginType) {
        self.localStorage.loginType = type
    }
    
    func logout() -> Observable<Result<Void,Error>> {
        authNetworkService.logout()
    }
    
    func withdraw() -> Observable<Result<Void,Error>> {
        authNetworkService.withdraw()
    }
    
    func checkVersion(currentVersion: String) -> Observable<Result<Bool, Error>> {
        let request = VersionRequestDTO(currentVersion: currentVersion)
        return versionNetworkService.checkVersion(request: request)
    }
}
