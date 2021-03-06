//
//  MyPageSectionModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/21.
//

import Foundation
import RxDataSources

enum MyPageSectionModel {
    case profileSection(title: String, items: [MyPageSectionItem])
    case pointSection(title: String, items: [MyPageSectionItem])
    case itemListSection(title: String, items: [MyPageSectionItem])
}

enum MyPageSectionItem {
    case profileSectionItem(user: User, loginType: LoginType)
    case pointSectionItem(point: Int)
    case itemListSectionItem(item: MyPageItem)
}

extension MyPageSectionModel: SectionModelType {
    init(original: MyPageSectionModel, items: [MyPageSectionItem]) {
        switch original {
        case .profileSection(title: let title, _):
            self = .profileSection(title: title, items: items)
        case .pointSection(title: let title, _):
            self = .pointSection(title: title, items: items)
        case .itemListSection(title: let title, _):
            self = .itemListSection(title: title, items: items)
        }
    }
    
    typealias Item = MyPageSectionItem
    
    var items: [Item] {
        switch self {
        case .profileSection(_, let items):
            return items
        case .pointSection(_, let items):
            return items
        case .itemListSection(title: _, items: let items):
            return items
        }
    }
    
}
