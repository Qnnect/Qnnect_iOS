//
//  Cafe.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/06.
//

import Foundation

struct Cafe {
    let questions: [Question]
    let cafeUsers: [CafeUser]
    let code: String
    let createdAt: String
    let currentUser: CafeUser
    let organizer: Bool
    let title:String
}

struct CafeUser {
    //let filledIngredients
    let userInfo: User
    let userDrinkSelected: String?
}


