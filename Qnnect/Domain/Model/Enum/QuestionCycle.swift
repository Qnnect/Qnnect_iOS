//
//  QuestionCycle.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/06.
//

import Foundation

enum QuestionCycle: String, CaseIterable, Codable {
    case every = "everyDay"
    case three = "threeDay"
    case five = "fiveDay"
    case seven = "sevenDay"
    
    var title: String {
        switch self {
        case .every:
            return "매일"
        case .three:
            return "3일"
        case .five:
            return "5일"
        case .seven:
            return "7일"
        }
    }
}
