//
//  StampResponseDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/29.
//

import Foundation

struct StampResponseDTO: Decodable {
    let cafeName: String
    let drinkName: String
    
    func toDomain() -> Stamp {
        Stamp(cafeName: cafeName, drinkName: drinkName)
    }
}
