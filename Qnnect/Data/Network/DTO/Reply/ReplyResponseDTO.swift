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
    let writerInfo: ProfileResponseDTO
    let writer: Bool
    func toDomain() -> Reply {
        Reply(
            content: content,
            createdAt: createdAt,
            id: replyId,
            writerInfo: writerInfo.toDomain(),
            writer: writer
        )
    }
}
