//
//  CafeCreateResponseDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/06.
//

import Foundation

struct CafeCreateResponseDTO: Decodable {
    let cafeId: Int
    
    func toDomain() -> Int {
        return cafeId
    }
}
