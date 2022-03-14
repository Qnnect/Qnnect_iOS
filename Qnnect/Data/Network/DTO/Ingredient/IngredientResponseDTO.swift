//
//  IngredientFetchResponseDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/14.
//

import Foundation

struct IngredientResponseDTO: Decodable {
    let id: Int
    let ingredientType: IngredientType
    let name: String
    let point: Int
    
    func toDomain() -> Ingredient {
        Ingredient(
            id: id,
            type: ingredientType,
            name: name,
            price: point
        )
    }
}
