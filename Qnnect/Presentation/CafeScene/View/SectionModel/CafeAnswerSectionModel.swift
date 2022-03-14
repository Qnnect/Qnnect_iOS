//
//  CafeAnswerSectionModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/08.
//

import Foundation
import RxDataSources

enum CafeAnswerSectionModel {
    case questionSection(title: String, items: [CafeAnswerSectionItem])
    case answerWritingSection(title: String, items: [CafeAnswerSectionItem])
}

enum CafeAnswerSectionItem {
    case questionSectionItem(question: Question)
    case answerWritingSectionItem(user: User)
}

extension CafeAnswerSectionItem: IdentifiableType, Equatable {
    
    typealias Identity = String
    
    static func == (lhs: CafeAnswerSectionItem, rhs: CafeAnswerSectionItem) -> Bool {
        switch (lhs,rhs) {
        case (.questionSectionItem, .questionSectionItem),
            (.answerWritingSectionItem, .answerWritingSectionItem):
            return true
        default:
            return false
        }
    }
    
    var identity: Identity {
           return UUID().uuidString
    }
}

extension CafeAnswerSectionModel: AnimatableSectionModelType {
    
    typealias Identity = String
    
    var identity: Identity {
        return UUID().uuidString
    }
    
    
    init(original: CafeAnswerSectionModel, items: [CafeAnswerSectionItem]) {
        switch original {
        case .questionSection(title: let title, _):
            self = .questionSection(title: title, items: items)
        case .answerWritingSection(title: let title, _):
            self = .answerWritingSection(title: title, items: items)
        }
    }
    
    typealias Item = CafeAnswerSectionItem
    
    var items: [Item] {
        switch self {
        case .questionSection(_, let items):
            return items
        case .answerWritingSection(_, let items):
            return items
            
        }
    }
}
