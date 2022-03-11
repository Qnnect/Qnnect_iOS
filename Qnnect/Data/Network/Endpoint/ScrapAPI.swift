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
    case fetchAllScrap(request: ScrapFetchRequestDTO)
    case fetchScrap(cafeId: Int, request: ScrapFetchRequestDTO)
    case fetchCafes
}

extension ScrapAPI: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        return APP.baseURL
    }
    
    var path: String {
        switch self {
        case .scrap(_), .cancleScrap(_):
            return "api/v1/users/scrap"
        case .fetchAllScrap(_):
            return "api/v1/users/scrap/all"
        case .fetchScrap(let cafeId, _):
            return "api/v1/users/scrap/\(cafeId)"
        case .fetchCafes:
            return "api/v1/scrap/cafes"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .scrap(_):
            return .post
        case .cancleScrap(_):
            return .delete
        case .fetchAllScrap(_), .fetchScrap(_, _), .fetchCafes:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .scrap(let request), .cancleScrap(let request):
            let param = request.toDictionary() ?? [:]
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        case .fetchAllScrap(let request), .fetchScrap(_, let request):
            let param = request.toDictionary() ?? [:]
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        case .fetchCafes:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var authorizationType: AuthorizationType? {
        return .bearer
    }
    
    
}
