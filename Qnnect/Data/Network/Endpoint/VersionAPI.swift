//
//  VersionAPI.swift
//  Qnnect
//
//  Created by 재영신 on 2022/04/03.
//

import Foundation
import Moya

enum VersionAPI {
    case checkVersion(request: VersionRequestDTO)
}

extension VersionAPI: TargetType {
    var baseURL: URL {
        APP.baseURL
    }
    
    var path: String {
        switch self {
        case .checkVersion(_):
            return "api/v1/version"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkVersion(_):
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .checkVersion(let request):
            let param = request.toDictionary() ?? [:]
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        nil
    }
    
}
