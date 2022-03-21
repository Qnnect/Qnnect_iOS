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
    let diaryColor: DiaryColorType
    let title:String
    let cafeId: Int
    let cafeUserId: Int
}

struct CafeUser {
    let drinkInfo: CafeDrink
    let userInfo: User
}


