//
//  GroupType.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/06.
//

import Foundation

enum GroupType: String, CaseIterable, Codable {
    case friend = "친구"
    case family = "가족"
    case couple = "커플"
    
    var title: String {
        switch self {
        case .friend, .family, .couple:
            return self.rawValue
        }
    }
}
