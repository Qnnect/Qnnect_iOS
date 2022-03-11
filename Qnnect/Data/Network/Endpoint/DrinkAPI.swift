//
//  DrinkAPI.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/11.
//

import Foundation
import Moya

enum DrinkAPI {
    case fetchDrinks
    case selectDrink(cafeId: Int, request: DrinkSelectRequestDTO)
}

extension DrinkAPI: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        APP.baseURL
    }
    
    var path: String {
        switch self {
        case .fetchDrinks:
            return "api/v1/drinks"
        case .selectDrink(let cafeId, _):
            return "api/v1/diaries/\(cafeId)/drinks"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchDrinks:
            return .get
        case .selectDrink(_, _):
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .fetchDrinks:
            return .requestPlain
        case .selectDrink(_, let request):
            let param = request.toDictionary() ?? [:]
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var authorizationType: AuthorizationType? {
        .bearer
    }
    
    
}
