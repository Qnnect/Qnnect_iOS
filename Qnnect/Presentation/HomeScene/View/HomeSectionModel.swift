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
    case myCafeSection(title: String, items: [HomeSectionItem])
}
enum HomeSectionItem {
    case titleSectionItem(user: User)
    case todayQuestionSectionItem(question: ToDayQuestion)
    case myCafeSectionItem(cafe: MyCafe)
    case todayQuestionSectionEmptyItem
}

extension HomeSectionModel: SectionModelType {
    init(original: HomeSectionModel, items: [HomeSectionItem]) {
        switch original {
        case .titleSection(title: let title, _):
            self = .titleSection(title: title, items: items)
        case .todayQuestionSection(title: let title, _):
            self = .todayQuestionSection(title: title, items: items)
        case .myCafeSection(title: let title, _):
            self = .myCafeSection(title: title, items: items)
        }
    }
    
    typealias Item = HomeSectionItem
    
    var items: [Item] {
        switch self {
        case .titleSection(_, let items):
            return items
        case .todayQuestionSection(_, let items):
            return items
        case .myCafeSection(title: _, items: let items):
            return items
        }
    }
    
    var title: String {
        switch self {
        case .titleSection(let title, _):
            return title
        case .todayQuestionSection(let title, _):
            return title
        case .myCafeSection(let title, _):
            return title
        }
    }
}
