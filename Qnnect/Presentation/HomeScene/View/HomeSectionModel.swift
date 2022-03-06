//
//  HomeSectionModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/18.
//

import Foundation
import RxDataSources

enum HomeSectionModel {
    case titleSection(title: String, items: [HomeSectionItem])
    case todayQuestionSection(title: String, items: [HomeSectionItem])
    case mygroupSection(title: String, items: [HomeSectionItem])
}
enum HomeSectionItem {
    case titleSectionItem(user: User)
    case todayQuestionSectionItem(question: Question_test)
    case mygroupSectionItem(group: Group)
}

extension HomeSectionModel: SectionModelType {
    init(original: HomeSectionModel, items: [HomeSectionItem]) {
        switch original {
        case .titleSection(title: let title, _):
            self = .titleSection(title: title, items: items)
        case .todayQuestionSection(title: let title, _):
            self = .todayQuestionSection(title: title, items: items)
        case .mygroupSection(title: let title, _):
            self = .mygroupSection(title: title, items: items)
        }
    }
    
    typealias Item = HomeSectionItem
    
    var items: [Item] {
        switch self {
        case .titleSection(_, let items):
            return items
        case .todayQuestionSection(_, let items):
            return items
        case .mygroupSection(title: _, items: let items):
            return items
        }
    }
    
    var title: String {
        switch self {
        case .titleSection(let title, _):
            return title
        case .todayQuestionSection(let title, _):
            return title
        case .mygroupSection(let title, _):
            return title
        }
    }
}
