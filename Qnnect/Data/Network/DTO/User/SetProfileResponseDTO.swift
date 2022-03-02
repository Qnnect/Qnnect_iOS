//
//  UserResponseDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/02.
//

import Foundation

struct SetProfileResponseDTO: Decodable {
    let profileImage: String
    let nickName: String
    let point: Int
    
    func toDomain() -> User {
        return User(name: self.nickName, point: self.point, profileImage: self.profileImage)
    }
}
