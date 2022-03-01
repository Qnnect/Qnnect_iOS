//
//  Token.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/01.
//

import Foundation

struct Token: Codable {
    let access: String
    let refresh: String
    let type: LoginType
}
