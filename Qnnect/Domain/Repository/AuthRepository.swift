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
    func saveToken(token: Token)
    func reissueToken(token: Token) -> Observable<Result<Token,Error>>
    func updateFirstAccess()
    func saveLoginType(_ type: LoginType) 
}
