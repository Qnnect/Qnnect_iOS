//
//  DrinkAPI.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/11.
//

import Foundation
import Moya

enum DrinkAPI {
    case fetchDrinks
}

extension DrinkAPI: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        APP.baseURL
    }
    
    var path: String {
        switch self {
        case .fetchDrinks:
            return "api/v1/drinks"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchDrinks:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .fetchDrinks:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var authorizationType: AuthorizationType? {
        .bearer
    }
    
    
}
