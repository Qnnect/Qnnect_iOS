//
//  CafeQuestionResponseDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/05.
//

import Foundation

struct CafeQuestionResponseDTO: Decodable {
    let createAt: String
    let daysLeft: Int
    let question: String
    let questioner: String
    
    func toDomain() -> Question {
        return Question(
            createAt: self.createAt,
            daysLeft: self.daysLeft,
            qustion: self.question,
            questioner: self.questioner
        )
    }
}
