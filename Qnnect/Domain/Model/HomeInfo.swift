//
//  HomeInfo.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/07.
//

import Foundation

struct HomeInfo {
    let cafes: [MyCafe]
    let questions: [ToDayQuestion]
    let user: User
}

struct MyCafe {
    let cafeUserNum: Int
    let createdAt: String
    let id: Int
    let title: String
}

struct ToDayQuestion {
    let cafeQuestionId: Int
    let cafeTitle: String
    let content: String
    let daysLeft: Int
}
