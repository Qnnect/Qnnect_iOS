//
//  QuestionResponseDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/05.
//

import Foundation

struct QuestionResponseDTO: Decodable {
    let createdAt: String
    let daysLeft: Int
    let question: String
    let questioner: String
    let cafeQuestionId: Int
    let writer: Bool
    
    func toDomain() -> Question {
        return Question(
            createdAt: self.createdAt,
            daysLeft: self.daysLeft,
            content: self.question,
            questioner: self.questioner,
            id: self.cafeQuestionId,
            writer: self.writer
        )
    }
}
