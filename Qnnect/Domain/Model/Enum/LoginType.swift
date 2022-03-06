//
//  File.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/05.
//

import Foundation

enum LoginType: String,Codable {
    case kakao
    case apple
    case unknown
    
    var title: String {
        switch self {
        case .kakao:
            return "카카오계정으로 로그인하셨어요!"
        case .apple:
            return "애플계정으로 로그인하셨어요!"
        case .unknown:
            return "알수없음으로 로그인하셨어요!"
        }
    }
}
