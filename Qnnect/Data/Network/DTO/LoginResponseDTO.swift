//
//  LoginResponseDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/23.
//

import Foundation

struct LoginResponseDTO: Codable {
    let accessToken: String
    let isNewMember: Bool
    let refreshToken: String
    let userSettingDone: Bool
    
    func toDomain() -> UserLoginInfo {
        return UserLoginInfo(
            accessToken: self.accessToken,
            isNewMember: self.isNewMember,
            refreshToken: self.refreshToken,
            userSettingDone: self.userSettingDone
        )
    }
}


