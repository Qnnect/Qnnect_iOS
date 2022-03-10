//
//  ScrapAPI.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/10.
//

import Foundation
import Moya

enum ScrapAPI {
    case scrap(request: ScrapRequestDTO)
    case cancleScrap(request: ScrapRequestDTO)
}

extension ScrapAPI: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        return APP.baseURL
    }
    
    var path: String {
        switch self {
        case .scrap(_), .cancleScrap(_):
            return "api/v1/users/scrap"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .scrap(_):
            return .post
        case .cancleScrap(_):
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .scrap(let request), .cancleScrap(let request):
            let param = request.toDictionary() ?? [:]
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var authorizationType: AuthorizationType? {
        return .bearer
    }
    
    
}
