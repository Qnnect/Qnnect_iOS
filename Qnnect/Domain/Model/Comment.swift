//
//  Comment.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/14.
//

import Foundation

struct Comment {
    let id: Int
    let content: String
    let createdAt: String
    let imageUrl1: String?
    let imageUrl2: String?
    let imageUrl3: String?
    let imageUrl4: String?
    let imageUrl5: String?
    let writerInfo: User
    /// 질문과 함께 가져오는 답변에는 response에 writer가 없어서 nil, 댓글과 가져올때는 값이 있다
    let writer: Bool?
    let replyCount: Int
    
    func getImageURLs() -> [String] {
        [
            imageUrl1,
            imageUrl2,
            imageUrl3,
            imageUrl4,
            imageUrl5
        ].compactMap { $0 }
    }
}
