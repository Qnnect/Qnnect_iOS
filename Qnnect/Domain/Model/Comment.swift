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
    let writer: User
    let replyCount: Int
}
