//
//  CafeDrinkFetchResponseDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/17.
//

import Foundation

struct OurCafeFetchResponseDTO: Decodable {
    let cafeUsers: [OurCafeUserResponseDTO]
    let currentDrinkInfo: CafeDrinkInfoResponseDTO
    let currentUser: Bool
    
    func toDomain() -> OurCafe {
        OurCafe(
            cafeUsers: cafeUsers.map { $0.toDomain() },
            selectedUserDrinkInfo: currentDrinkInfo.toDomain(),
            currentUser: currentUser
        )
    }
}

struct CafeDrinkInfoResponseDTO: Decodable {
    let base: Int
    let baseFilled: Int
    let currentDrinkIngredientsFilled: [DrinkIngredientsFilledResponseDTO]
    let ice: Int
    let iceFilled: Int
    let main: Int
    let mainFilled: Int
    let topping: Int
    let toppingFilled: Int
    let userDrinkSelectedId: Int
    
    func toDomain() -> CafeDrink {
        CafeDrink(
            base: base,
            baseFilled: baseFilled,
            currentDrinkIngredientsFilled: currentDrinkIngredientsFilled.map { $0.toDomain()} ,
            ice: ice,
            iceFilled: iceFilled,
            main: main,
            mainFilled: mainFilled,
            topping: topping,
            toppingFilled: toppingFilled,
            userDrinkSelectedId: userDrinkSelectedId
        )
    }
}
