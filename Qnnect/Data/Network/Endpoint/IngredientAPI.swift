//
//  IngredientAPI.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/14.
//

import Foundation
import Moya

enum IngredientAPI {
    case fetchAllIngredient
    case fetchIngredients(type: IngredientType)
    case buyIngredient(ingredientsId: Int)
    case fetchAllMeIngredient
    case fetchMeIngredients(type: IngredientType)
}

extension IngredientAPI: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        APP.baseURL
    }
    
    var path: String {
        switch self {
        case .fetchAllIngredient:
            return "api/v1/ingredients/all"
        case .fetchIngredients(let type):
            return "api/v1/ingredients/\(type.rawValue)"
        case .buyIngredient(ingredientsId: let id):
            return "api/v1/ingredients/\(id)"
        case .fetchAllMeIngredient:
            return "api/v1/ingredients/me/all"
        case .fetchMeIngredients(let type):
            return "api/v1/ingredients/me/\(type.rawValue)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchIngredients(_), .fetchAllIngredient, .fetchAllMeIngredient, .fetchMeIngredients(_):
            return .get
        case .buyIngredient(_):
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .fetchIngredients(_), .fetchAllIngredient, .buyIngredient(_), .fetchAllMeIngredient, .fetchMeIngredients(_):
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
