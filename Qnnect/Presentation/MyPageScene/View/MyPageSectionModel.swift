//
//  MyPageSectionModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/21.
//

import Foundation
import RxDataSources

enum MyPageItem: String, CaseIterable {
    case setNoti
    case notice
    case instagram
    case premium
    case logout
    
    var title:String {
        switch self {
        case .setNoti:
            return "알림 설정"
        case .notice:
            return "공지사항"
        case .instagram:
            return "큐넥트 인스타그램"
        case .premium:
            return "프리미엄 (준비중)"
        case .logout:
            return "로그아웃"
        }
    }
}
enum MyPageSectionModel {
    case profileSection(title: String, items: [MyPageSectionItem])
    case pointSection(title: String, items: [MyPageSectionItem])
    case itemListSection(title: String, items: [MyPageSectionItem])
}

enum MyPageSectionItem {
    case profileSectionItem(user: User)
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
