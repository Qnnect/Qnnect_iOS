//
//  FetchUserResponseDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/04.
//

import Foundation

struct FetchUserResponseDTO: Decodable {
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
