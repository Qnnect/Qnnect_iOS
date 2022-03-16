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
    case modifyQuestion(questionId: Int, content: String)
    case deleteQuestion(questionId: Int)
    case fetchCafeQuestions(cafeId: Int, request: CafeQuestionsFetchRequestDTO)
    case searchCafeQuestion(cafeId: Int, request: CafeQuestionSearchRequestDTO)
}

extension QuestionAPI: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        APP.baseURL
    }
    
    var path: String {
        switch self {
        case .fetchQuestion(let questionId), .modifyQuestion(let questionId, _), .deleteQuestion(let questionId):
            return "api/v1/question/\(questionId)"
        case .fetchCafeQuestions(let cafeId, _):
            return "api/v1/question/cafes/\(cafeId)/all"
        case .searchCafeQuestion(let cafeId, _):
            return "api/v1/question/cafes/\(cafeId)/search"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchQuestion(_), .fetchCafeQuestions(_, _), .searchCafeQuestion(_, _):
            return .get
        case .modifyQuestion(_, _):
            return .patch
        case .deleteQuestion(_):
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .fetchQuestion(_), .deleteQuestion(_):
            return .requestPlain
        case .modifyQuestion(_, let content):
            return .requestData(content.data(using: .utf8)!)
        case .fetchCafeQuestions(_, let request):
            let param = request.toDictionary() ?? [:]
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        case .searchCafeQuestion(_, let request):
            let param = request.toDictionary() ?? [:]
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .modifyQuestion(_, _):
            return ["Content-Type": "text/plain"]
        default:
            return nil
        }
    }
    
    var authorizationType: AuthorizationType? {
        .bearer
    }
    
    
}
