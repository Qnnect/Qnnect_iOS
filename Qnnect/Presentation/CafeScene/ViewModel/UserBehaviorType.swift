//
//  UserBehaviorType.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/07.
//

import Foundation

enum UserBehaviorType: String {
    case answer = "답변"
    case question = "질문"
    
    var notSelectGuideTitleMessage: String {
        switch self {
        case .question:
            return "\(self.rawValue)을 달 수 없어요! \n 음료를 먼저 골라주세요"
        case .answer:
            return "\(self.rawValue)을 할 수 없어요!. \n 음료를 먼저 골라주세요"
        }
    }
    
    var notSelectGuideSecondaryMessage: String {
        switch self {
        case .question:
            return "먼저 음료를 골라야 \(self.rawValue)을 달 수 있어요"
        case .answer:
            return "먼저 음료를 골라야 \(self.rawValue)을 할 수 있어요"
        }
    }
}
