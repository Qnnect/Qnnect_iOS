//
//  CommentCreateError.swift
//  Qnnect
//
//  Created by 재영신 on 2022/04/04.
//

import Foundation

enum CommentCreateError: Error {
    case notSelectDrink
    case unknown
    
    init(statusCode: Int) {
        switch statusCode {
        case 401:
            self = .notSelectDrink
        default:
            self = .unknown
        }
    }
    
    var message: String {
        switch self {
        case .notSelectDrink:
            return "음료를 선택하지 않아\n답변을 할 수 없습니다."
        case .unknown:
            return "unknown Error"
        }
    }
}
