//
//  UserRequestDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/02.
//

import Foundation

struct ProfileRequestDTO: Encodable {
    let profilePicture: Data
    let nickName: String
}
