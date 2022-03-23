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
    case reissue(request: ReissueRequestDTO)
    case logout
    case withdrawl
}

extension AuthAPI: TargetType, AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        switch self {
        case .logout, .withdrawl:
            return .bearer
        case .login(_), .reissue(_):
            return .none
        }
    }
    
    var baseURL: URL {
        return APP.baseURL
    }
    
    var path: String {
        switch self {
        case .login(_):
            return "api/v1/auth/login"
        case .reissue(_):
            return "api/v1/auth/reissue"
        case .logout:
            return "api/v1/auth/logout"
        case .withdrawl:
            return "api/v1/auth/withdrawl"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login(_):
            return .post
        case .reissue(_):
            return .post
        case .logout, .withdrawl:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .login(let loginRequestDTO):
            return .requestJSONEncodable(loginRequestDTO)
        case .reissue(let reissueRequestDTO):
            return .requestJSONEncodable(reissueRequestDTO)
        case .logout, .withdrawl:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
}
