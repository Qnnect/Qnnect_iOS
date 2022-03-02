//
//  loginRequestDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/23.
//

import Foundation

struct LoginRequestDTO: Codable {
    let accessToken: String
    let loginType: LoginType
}
