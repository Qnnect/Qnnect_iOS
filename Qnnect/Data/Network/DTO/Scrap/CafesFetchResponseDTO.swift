//
//  CafesFetchResponseDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/11.
//

import Foundation

struct CafesFetchResponseDTO: Decodable {
    let cafeId: Int
    let cafeTitle: String
    
    func toDomain() -> CafeTag {
        CafeTag(cafeId: cafeId, cafeTitle: cafeTitle)
    }
}
