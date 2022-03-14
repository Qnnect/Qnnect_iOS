//
//  ReplyResponseDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/14.
//

import Foundation

struct ReplyResponseDTO: Decodable {
    let content: String
    let createdAt: String
    let replyId: Int
    let writer: ProfileResponseDTO
    
    func toDomain() -> Reply {
        Reply(content: content, createdAt: createdAt, id: replyId, writer: writer.toDomain())
    }
}
