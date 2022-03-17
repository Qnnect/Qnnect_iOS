//
//  OurCafeUserResponseDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/17.
//

import Foundation

struct OurCafeUserResponseDTO: Decodable {
    let cafeUserId: Int
    let nickName: String
    let profileImage: String
    
    func toDomain() -> OurCafeUser {
        OurCafeUser(
            cafeUserId: cafeUserId,
            nickName: nickName,
            profileImage: profileImage
        )
    }
}
