//
//  QuestionAPI.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/14.
//

import Foundation
import Moya

enum QuestionAPI {
    case fetchQuestion(questionId: Int)
}

extension QuestionAPI: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        APP.baseURL
    }
    
    var path: String {
        switch self {
        case .fetchQuestion(let questionId):
            return "api/v1/question/\(questionId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchQuestion(_):
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .fetchQuestion(_):
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        nil
    }
    
    var authorizationType: AuthorizationType? {
        .bearer
    }
    
    
}
