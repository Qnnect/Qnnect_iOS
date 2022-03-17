//
//  CafeUserResponseDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/06.
//

import Foundation

struct CafeUserResponseDTO: Decodable {
    let drinkIngredientsFilledResponseList: [DrinkIngredientsFilledResponseDTO]
    let user: ProfileResponseDTO
    let userDrinkSelected: String?
    
    func toDomain() -> CafeUser {
        return CafeUser(
            userInfo: self.user.toDomain(),
            userDrinkSelected: self.userDrinkSelected 
        )
    }
}

struct DrinkIngredientsFilledResponseDTO: Decodable {
    let ingredientName: String
    
    func toDomain() -> String {
        ingredientName
    }
}


