//
//  UserAPI.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/02.
//

import Foundation
import Moya

enum UserAPI {
    case setProfile(request: SetProfileRequestDTO)
    case setEnableNotification(request: SetEnableNotificationRequestDTO)
}

extension UserAPI: TargetType {
    var baseURL: URL {
        return APP.baseURL
    }
    
    var path: String {
        switch self {
        case .setProfile(_):
            return "api/v1/user/profile"
        case .setEnableNotification(_):
            return "api/v1/user/enablenotification"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .setProfile(_):
            return .patch
        case .setEnableNotification(_):
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .setProfile(let request):
            return .requestJSONEncodable(request)
        case .setEnableNotification(let request):
            let param = request.toDictionary() ?? [:]
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
}
