//
//  CafeSectionModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/06.
//

import Foundation
import RxDataSources

enum CafeRoomSectionModel {
    case titleSection(title: String, items: [CafeRoomSectionItem])
    case cafeDrinksSection(title: String, items: [CafeRoomSectionItem])
    case todayQuestionSection(title: String, items: [CafeRoomSectionItem])
}
enum CafeRoomSectionItem {
    case titleSectionItem(cafe: Cafe)
    case cafeDrinksSection(cafeUser: CafeUser)
    case todayQuestionSectionItem(question: Question)
}

extension CafeRoomSectionModel: SectionModelType {
    init(original: CafeRoomSectionModel, items: [CafeRoomSectionItem]) {
        switch original {
        case .titleSection(title: let title, _):
            self = .titleSection(title: title, items: items)
        case .cafeDrinksSection(title: let title, _):
            self = .cafeDrinksSection(title: title, items: items)
        case .todayQuestionSection(title: let title, _):
            self = .todayQuestionSection(title: title, items: items)
        }
    }
    
    typealias Item = CafeRoomSectionItem
    
    var items: [Item] {
        switch self {
        case .titleSection(_, let items):
            return items
        case .cafeDrinksSection(_, let items):
            return items
        case .todayQuestionSection(_, let items):
            return items
        }
    }
    

}
