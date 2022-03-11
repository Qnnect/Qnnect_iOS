//
//  DrinkFetchResponseDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/11.
//

import Foundation

struct DrinkFetchResponseDTO: Decodable {
    let id: Int
    let name: String
    let recipe: String?
    
    func toDomain() -> Drink {
        Drink(
            id: id,
            name: name,
            recipe: recipe
        )
    }
}
