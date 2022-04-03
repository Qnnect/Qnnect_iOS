//
//  MyPageItem.swift
//  Qnnect
//
//  Created by 재영신 on 2022/04/03.
//

import Foundation

enum MyPageItem: String, CaseIterable {
    //case notice
    case reportManagement
    case instagram
    case setNoti
    //case premium
    case privacyPolicy
    case termsOfService
    case logout
    case withdrawal
    
    var title:String {
        switch self {
        case .setNoti:
            return "알림 설정"
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
