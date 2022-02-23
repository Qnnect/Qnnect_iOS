//
//  AuthAPIEndPoint.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/23.
//

import Foundation
import Moya

enum AuthAPIEndPoint {
    case login(accessToken: String,type: LoginType)
}

extension AuthAPIEndPoint: TargetType {
    var baseURL: URL {
        return APP.baseURL
    }
    
    var path: String {
        switch self {
        case .login(_, _):
            return "​/api​/v1​/auth​/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login(accessToken: _, type: _):
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .login(let accessToken, let type):
            let param = [
                "accessToken": accessToken,
                "loginType": type.rawValue
            ]
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
}
