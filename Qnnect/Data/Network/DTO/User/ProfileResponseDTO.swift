//
//  UserResponseDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/02.
//

import Foundation

struct ProfileResponseDTO: Decodable {
    let profileImage: String?
    let nickName: String
    let point: Int
    let reportId: Int
    
    func toDomain() -> User {
        return User(
            name: self.nickName,
            point: self.point,
            profileImage: self.profileImage,
            reportId: reportId
        )
    }
}
