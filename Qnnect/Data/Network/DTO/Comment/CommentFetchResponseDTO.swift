//
//  CommentFetchResponseDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/14.
//

import Foundation

struct CommentFetchResponseDTO: Decodable {
    let commentId: Int
    let content: String
    let createdAt: String
    let imageUrl1: String?
    let imageUrl2: String?
    let imageUrl3: String?
    let imageUrl4: String?
    let imageUrl5: String?
    let replies: [ReplyResponseDTO]
    let writer: ProfileResponseDTO
    
    func toDomain() -> (comment: Comment, replies: [Reply]) {
        (
            Comment(
            id: commentId,
            content: content,
            createdAt: createdAt,
            imageUrl1: imageUrl1,
            imageUrl2: imageUrl2,
            imageUrl3: imageUrl3,
            imageUrl4: imageUrl4,
            imageUrl5: imageUrl5,
            writer: writer.toDomain(),
            replyCount: replies.count
            ),
            replies.map { $0.toDomain() }
        )
    }
}
