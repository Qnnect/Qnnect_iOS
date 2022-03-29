//
//  Notification+.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/29.
//

import UIKit

extension NotificationType {
    var icon: UIImage? {
        switch self {
        case .comment:
            return Constants.noti_comment_icon
        case .question:
            return Constants.noti_question_icon
        case .reply:
            return Constants.noti_reply_icon
        }
    }
}
