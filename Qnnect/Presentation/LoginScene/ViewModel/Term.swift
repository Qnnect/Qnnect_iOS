//
//  Term.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/16.
//

import Foundation

enum Term:CaseIterable {
    case personal
    case service
    case pushnoti
    case all
    
    var agreementType: Agreement {
        switch self {
        case .personal:
            return .essential
        case .service:
            return .essential
        case .pushnoti:
            return .choice
        case .all:
            return .all
        }
    }
    
    var title: String {
        switch self {
        case .personal:
            return "개인정보 처리방침 \(self.agreementType.rawValue)"
        case .service:
            return "서비스 이용약관 \(self.agreementType.rawValue)"
        case .pushnoti:
            return "푸쉬 알림 동의 여부 \(self.agreementType.rawValue)"
        case .all:
            return "네. 모두 동의합니다"
        }
    }
    
}


enum Agreement: String {
    case essential = "필수"
    case choice = "선택"
    case all
}
