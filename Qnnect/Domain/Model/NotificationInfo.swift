//
//  Notification.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/29.
//

import Foundation

enum NotificationType: Decodable {
    case comment
    case question
    case reply
}

struct NotificationInfo {
    let content: String
    let createdAt: String
    let groupName: String
    let id: Int
    let type: NotificationType
    let userRead: Bool
}
