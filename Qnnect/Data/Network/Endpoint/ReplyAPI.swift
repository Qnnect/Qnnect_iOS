//
//  ReplyAPI.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/15.
//

import Foundation
import Moya

enum ReplyAPI {
    case createReply(commentId: Int, content: String)
}

extension ReplyAPI: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        APP.baseURL
    }
    
    var path: String {
        switch self {
        case .createReply(let commentId, _):
            return "api/v1/comments/\(commentId)/reply"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createReply(_, _):
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .createReply(_, let content):
            return .requestData(content.data(using: .utf8)!)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .createReply(_, _):
            return ["Content-Type": "text/plain"]
        }
    }
    
    var authorizationType: AuthorizationType? {
        .bearer
    }
    
    
}
