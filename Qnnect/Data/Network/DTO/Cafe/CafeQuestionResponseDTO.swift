//
//  CafeQuestionResponseDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/05.
//

import Foundation

struct CafeQuestionResponseDTO: Decodable {
    let createdAt: String
    let daysLeft: Int
    let question: String
    let questioner: String
    
    func toDomain() -> Question {
        return Question(
            createdAt: self.createdAt,
            daysLeft: self.daysLeft,
            question: self.question,
            questioner: self.questioner
        )
    }
}
