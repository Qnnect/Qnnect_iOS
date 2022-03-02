//
//  ReissueResponseDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/02.
//

import Foundation

struct ReissueResponseDTO: Codable {
    let accessToken: String
    let refreshToken: String
    
    func toDomain() -> Token {
        return Token(access: self.accessToken, refresh: self.refreshToken)
    }
}
