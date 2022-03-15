//
//  LikeAPI.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/15.
//

import Foundation
import Moya

enum LikeAPI {
    case like(questionId: Int, request: LikeRequestDTO)
}

extension LikeAPI: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        APP.baseURL
    }
    
    var path: String {
        switch self {
        case .like(let questionId, _):
            return "api/v1/users/question/\(questionId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .like(_, _):
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .like(_, let request):
            let param = request.toDictionary() ?? [:]
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        nil
    }
    
    var authorizationType: AuthorizationType? {
        .bearer
    }
    
    
}
