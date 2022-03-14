//
//  QuestionFetchResponseDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/14.
//

import Foundation

struct QuestionFetchResponseDTO: Decodable {
    let comments: [CommentResponseDTO]
    let questionMainResponse: CafeQuestionResponseDTO
}
