//
//  QuestionFetchResponseDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/14.
//

import Foundation

struct QuestionFetchResponseDTO: Decodable {
    let comments: [CommentResponseDTO]
    let questionMainResponse: QuestionResponseDTO
    let currentUserComment: CommentResponseDTO?
    let liked: Bool
    let scraped: Bool
    
    func toDomain() -> CafeQuestion {
        CafeQuestion(
            comments: comments.map { $0.toDomain()},
            question: questionMainResponse.toDomain(),
            currentUserComment: currentUserComment?.toDomain(),
            liked: liked,
            scraped: scraped
        )
    }
}
