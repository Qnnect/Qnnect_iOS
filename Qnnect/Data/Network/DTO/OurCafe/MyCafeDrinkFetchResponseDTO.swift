//
//  MyCafeDrinkFetchResponseDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/17.
//

import Foundation

struct MyCafeDrinkFetchResponseDTO: Decodable {
    let currentDrinkInfo: CafeDrinkInfoResponseDTO
    let myIngredient: [MyIngredientResponseDTO]
    
    func toDomain() -> (cafeDrink: CafeDrink, ingredients: [MyIngredient]) {
        (currentDrinkInfo.toDomain(), myIngredient.map { $0.toDomain()})
    }
}
