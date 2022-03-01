//
//  LoginResponse.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/23.
//

import Foundation

struct UserLoginInfo {
    let accessToken: String
    let isNewMember: Bool
    let refreshToken: String
    let userSettingDone: Bool
}
