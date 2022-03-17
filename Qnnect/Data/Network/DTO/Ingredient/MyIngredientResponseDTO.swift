//
//  MyIngredientResponseDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/18.
//

import Foundation

struct MyIngredientResponseDTO: Decodable {
    let count: Int
    let ingredientId: Int
    let ingredientType: IngredientType
    let name: String
    
    func toDomain() -> MyIngredient {
        MyIngredient(
            count: count,
            ingredientId: ingredientId,
            type: ingredientType,
            name: name
        )
    }
}
