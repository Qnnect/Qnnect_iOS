//
//  GroupAPI.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/06.
//

import Foundation
import Moya

enum CafeAPI {
    case createCafe(request: CafeCreateRequestDTO)
    case fetchCafe(id: Int)
    case joinCafe(id: Int, request: CafeJoinRequestDTO)
    case updateCafe(id: Int, request: CafeUpdateRequestDTO)
    case leaveCafe(reqeust: CafeLeaveRequestDTO)
    case createQuestion(id: Int, request: QuestionCreateRequestDTO)
}

extension CafeAPI: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        return APP.baseURL
    }
    
    var path: String {
        switch self {
        case .createCafe(_):
            return "api/v1/cafes"
        case .fetchCafe(let id):
            return "api/v1/cafes/\(id)"
        case .joinCafe(let id, _):
            return "api/v1/cafes/\(id)"
        case .updateCafe(let id, _):
            return "api/v1/cafes/\(id)"
        case .leaveCafe(_):
            return "api/v1/cafes/leaver"
        case .createQuestion(let id, _):
            return "api/v1/cafes/\(id)/question/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createCafe(_):
            return .post
        case .fetchCafe(_):
            return .get
        case .joinCafe(_, _), .createQuestion(_, _):
            return .post
        case .updateCafe(_,_), .leaveCafe(_):
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .createCafe(let request):
            return .requestJSONEncodable(request)
        case .fetchCafe(_):
            return .requestPlain
        case .joinCafe(_, let request):
            let param = request.toDictionary() ?? [:]
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        case .updateCafe(_, let request):
            return .requestJSONEncodable(request)
        case .leaveCafe(let request):
            let param = request.toDictionary() ?? [:]
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        case .createQuestion(_, let request):
            return .requestJSONEncodable(request)
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json"
        ]
    }
    
    var authorizationType: AuthorizationType? {
        return .bearer
    }
}
