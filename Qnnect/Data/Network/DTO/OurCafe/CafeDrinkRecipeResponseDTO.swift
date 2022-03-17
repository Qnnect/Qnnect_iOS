//
//  CafeDrinkRecipeResponseDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/18.
//

import Foundation

struct CafeDrinkRecipeResponseDTO: Decodable {
    let currentDrinkInfo: CafeDrinkInfoResponseDTO
    let drinkRecipeResponses: [RecipeIngredientResponseDTO]
    
    func toDomain() -> (cafeDrink: CafeDrink, ingredients: [RecipeIngredient]) {
        (currentDrinkInfo.toDomain(), drinkRecipeResponses.map { $0.toDomain()})
    }
}
