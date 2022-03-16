//
//  CafeQuestionResponseDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/16.
//

import Foundation

struct CafeQuestionResponseDTO: Decodable {
    let cafeQuestionId: Int
    let cafeTitle: String
    let createdAt: String
    let question: String
    
    func toDomain() -> QuestionShortInfo {
        return QuestionShortInfo(
            cafeQuestionId: self.cafeQuestionId,
            cafeTitle: self.cafeTitle,
            createdAt: self.createdAt,
            content: self.question
        )
    }
}
