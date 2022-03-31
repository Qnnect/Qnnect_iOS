//
//  UserQuestionResponseDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/31.
//

import Foundation

struct UserQuestionResponseDTO: Decodable {
    let cafeQuestionId: Int
    let cafeTitle: String
    let createdAt: String
    let question: String
    let waitingList: Bool
    
    func toDomain() -> UserQuestion {
        UserQuestion(
            id: cafeQuestionId,
            cafeTitle: cafeTitle,
            createdAt: createdAt,
            content: question,
            waitingList: waitingList
        )
    }
}
