//
//  AuthRepository.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/23.
//

import Foundation
import RxSwift

protocol AuthRepository: AnyObject {
    func fetchIsFirstAccess() -> Bool
    func fetchToken() -> Token?
    func login(accessToken: String, type: LoginType) -> Observable<Result<UserLoginInfo, LoginError>>
    func saveToken(access: String, refresh: String)
    func reissueToken(token: Token) -> Observable<Result<Token,Error>>
    func updateFirstAccess()
    func saveLoginType(_ type: LoginType)
    func logout() -> Observable<Result<Void,Error>>
    func withdraw() -> Observable<Result<Void,Error>>
    func checkVersion(currentVersion: String) -> Observable<Result<Bool,Error>>
}
