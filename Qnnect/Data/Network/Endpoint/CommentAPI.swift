//
//  CommentAPI.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/14.
//

import Foundation
import Moya

enum CommentAPI {
    case createComment(cafeId: Int, questionId: Int, images: [Data], content: String)
}

extension CommentAPI: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        APP.baseURL
    }
    
    var path: String {
        switch self {
        case .createComment(let cafeId, let questionId, _, _):
            return "api/v1/cafes/\(cafeId)/questions/\(questionId)/comments"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createComment(_, _, _, _):
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .createComment(_, _, let images, let content):
            var formData: [Moya.MultipartFormData] = []
            images.enumerated().forEach {
                formData.append(Moya.MultipartFormData(
                    provider: .data($0.element),
                    name: "image\($0.offset)",
                    fileName: "image\($0.offset)",
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
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .createComment(_, _, _, _):
            return ["Content-Type": "multipart/form-data"]
        default:
            return nil
        }
    }
    
    var authorizationType: AuthorizationType? {
        .bearer
    }
}
