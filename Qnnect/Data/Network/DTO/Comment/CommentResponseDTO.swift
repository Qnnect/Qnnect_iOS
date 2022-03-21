//
//  CommentResponseDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/14.
//

import Foundation

struct CommentResponseDTO: Decodable {
    let commentId: Int
    let content: String
    let createdAt: String
    let imageUrl1: String?
    let imageUrl2: String?
    let imageUrl3: String?
    let imageUrl4: String?
    let imageUrl5: String?
    let profileResponse: ProfileResponseDTO
    let replyCount: Int
    
    func toDomain() -> Comment{
        Comment(
            id: commentId,
            content: content,
            createdAt: createdAt.replacingOccurrences(of: "-", with: "."),
            imageUrl1: imageUrl1,
            imageUrl2: imageUrl2,
            imageUrl3: imageUrl3,
            imageUrl4: imageUrl4,
            imageUrl5: imageUrl5,
            writerInfo: profileResponse.toDomain(),
            writer: nil,
            replyCount: replyCount
        )
    }
}
