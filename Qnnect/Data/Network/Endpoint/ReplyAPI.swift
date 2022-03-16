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
    case deleteReply(commentId: Int, replyId: Int)
    case modifyReply(commentId: Int, replyId: Int, content: String)
}

extension ReplyAPI: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        APP.baseURL
    }
    
    var path: String {
        switch self {
        case .createReply(let commentId, _):
            return "api/v1/comments/\(commentId)/reply"
        case .deleteReply(let commentId, let replyId):
            return "api/v1/comments/\(commentId)/reply/\(replyId)"
        case .modifyReply(let commentId, let replyId, _):
            return "api/v1/comments/\(commentId)/reply/\(replyId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createReply(_, _):
            return .post
        case .deleteReply(_, _):
            return .delete
        case .modifyReply(_, _, _):
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .createReply(_, let content):
            return .requestData(content.data(using: .utf8)!)
        case .deleteReply(_, _):
            return .requestPlain
        case .modifyReply(_, _, let content):
            return .requestData(content.data(using: .utf8)!)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .createReply(_, _), .modifyReply(_, _, _):
            return ["Content-Type": "text/plain"]
        default:
            return nil
        }
    }
    
    var authorizationType: AuthorizationType? {
        .bearer
    }
    
    
}
