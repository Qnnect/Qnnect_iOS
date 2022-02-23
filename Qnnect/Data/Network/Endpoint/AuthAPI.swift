//
//  AuthAPIEndPoint.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/23.
//

import Foundation
import Moya

enum AuthAPI {
    case login(request: LoginRequestDTO)
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return APP.baseURL
    }
    
    var path: String {
        switch self {
        case .login(_):
            return "​/api​/v1​/auth​/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login(_):
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .login(let loginRequestDTO):
            return .requestJSONEncodable(loginRequestDTO)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
}
