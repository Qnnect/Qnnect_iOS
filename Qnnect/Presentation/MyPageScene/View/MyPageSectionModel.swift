//
//  MyPageSectionModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/21.
//

import Foundation
import RxDataSources

enum MyPageItem: String, CaseIterable {
    //case setNoti
    //case notice
    case reportManagement
    case instagram
    //case premium
    case privacyPolicy
    case termsOfService
    case logout
    case withdrawal
    
    var title:String {
        switch self {
//        case .setNoti:
//            return "알림 설정"
//        case .notice:
//            return "공지사항"
        case .reportManagement:
            return "신고/차단친구 관리"
        case .instagram:
            return "큐넥트 인스타그램"
//        case .premium:
//            return "프리미엄 (준비중)"
        case .privacyPolicy:
            return "개인정보처리방침"
        case .termsOfService:
            return "서비스이용약관"
        case .logout:
            return "로그아웃"
        case .withdrawal:
            return "회원탈퇴"
        }
    }
}
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
