//
//  CafeQuestionsResponseDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/16.
//

import Foundation

struct CafeQuestionsResponseDTO: Decodable {
    let cafeQuestionList: [CafeQuestionResponseDTO]
    
    func toDomain() -> [QuestionShortInfo] {
        cafeQuestionList.map { $0.toDomain() }
    }
}
