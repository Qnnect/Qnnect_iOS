//
//  HomeAPI.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/07.
//

import Foundation
import Moya

enum HomeAPI {
    case fetchHomeInfo
}

extension HomeAPI: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        return APP.baseURL
    }
    
    var path: String {
        switch self {
        case .fetchHomeInfo:
            return "api/v1/home"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchHomeInfo:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .fetchHomeInfo:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json"
        ]
    }
    
    var authorizationType: AuthorizationType? {
        return .bearer
    }
}
