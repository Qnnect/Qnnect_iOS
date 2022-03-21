//
//  CafeUserResponseDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/06.
//

import Foundation

struct CafeUserResponseDTO: Decodable {
    let cafeDrinkCommonResponse: CafeDrinkInfoResponseDTO
    let user: ProfileResponseDTO
    
    func toDomain() -> CafeUser {
        return CafeUser(
            drinkInfo: cafeDrinkCommonResponse.toDomain(),
            userInfo: self.user.toDomain()
        )
    }
}

struct DrinkIngredientsFilledResponseDTO: Decodable {
    let ingredientName: String
    
    func toDomain() -> String {
        ingredientName
    }
}


