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
    func fetchToken() -> (access: String, refresh: String, type: LoginType)?
    func login(accessToken: String, type: LoginType) -> Observable<UserLoginInfo>
}