//
//  NotificationResponseDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/29.
//

import Foundation

struct NotificationResponseDTO: Decodable {
    let content: String
    let createdAt: String
    let groupName: String
    let notificationId: Int
    let notificationType: NotificationType
    let userRead: Bool
    
    func toDomain() -> NotificationInfo {
        NotificationInfo(
            content: content,
            createdAt: createdAt,
            groupName: groupName,
            id: notificationId,
            type: notificationType,
            userRead: userRead
        )
    }
}
