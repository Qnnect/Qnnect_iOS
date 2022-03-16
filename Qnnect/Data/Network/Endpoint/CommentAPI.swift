//
//  CommentAPI.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/14.
//

import Foundation
import Moya

enum CommentAPI {
    case createComment(questionId: Int, images: [Data], content: String)
    case fetchComment(commentId: Int)
    case deleteComment(commentId: Int)
    case modifyComment(commentId: Int, images: [Data], content: String)
}

extension CommentAPI: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        APP.baseURL
    }
    
    var path: String {
        switch self {
        case .createComment(let questionId, _, _):
            return "api/v1/questions/\(questionId)/comments"
        case .fetchComment(let commentId), .deleteComment(let commentId), .modifyComment(let commentId,_, _):
            return "api/v1/comments/\(commentId)"
        
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createComment(_, _, _):
            return .post
        case .fetchComment(_):
            return .get
        case .deleteComment(_):
            return .delete
        case .modifyComment(_, _, _):
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .createComment(_, let images, let content), .modifyComment(_, let images, let content):
            var formData: [Moya.MultipartFormData] = []
            images.enumerated().forEach {
                formData.append(Moya.MultipartFormData(
                    provider: .data($0.element),
                    name: "image\($0.offset+1)",
                    fileName: "image\(Int(Date().timeIntervalSince1970))",
                    mimeType: "image/png"
                ))
            }
            formData.append(Moya.MultipartFormData(
                provider: .data(content.data(using: .utf8)!),
                name: "content",
                fileName: "content",
                mimeType: nil
            ))
            return .uploadMultipart(formData)
        case .fetchComment(_), .deleteComment(_):
            return .requestPlain
            
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .createComment(_, _, _), .modifyComment(_, _, _):
            return ["Content-Type": "multipart/form-data"]
        case .fetchComment(_), .deleteComment(_):
            return nil
        }
    }
    
    var authorizationType: AuthorizationType? {
        .bearer
    }
}
