//
//  ReissueRequestDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/02.
//

import Foundation

struct ReissueRequestDTO: Codable {
    let accessToken: String
    let refreshToken: String
}
