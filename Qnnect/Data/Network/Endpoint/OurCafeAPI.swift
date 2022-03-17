//
//  OurCafeAPI.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/17.
//

import Foundation
import Moya

enum OurCafeAPI {
    case fetchOurCafe(cafeId: Int, cafeUserId: Int)
    case fetchMyCafeDrink(cafeId: Int)
    case insertIngredient(userDrinkSelectedId: Int, ingredientsId: Int)
    case fetchRecipe(userDrinkSelectedId:Int, request: RecipeFetchRequestDTO)
}

extension OurCafeAPI: TargetType, AccessTokenAuthorizable {
    
    var baseURL: URL {
        APP.baseURL
    }
    
    var path: String {
        switch self {
        case .fetchOurCafe(let cafeId, let cafeUserId):
            return "api/v1/cafe/\(cafeId)/drink/\(cafeUserId)"
        case .fetchMyCafeDrink(let cafeId):
            return "api/v1/cafe/\(cafeId)/my_ingredient"
        case .insertIngredient(let userDrinkSelectedId, let ingredientsId):
            return "api/v1/drinks/\(userDrinkSelectedId)/ingredients/\(ingredientsId)"
        case .fetchRecipe(let userDrinkSelectedId, _):
            return "api/v1/drinks/\(userDrinkSelectedId)/recipe"
            
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchOurCafe(_, _), .fetchMyCafeDrink(_), .fetchRecipe(_, _):
            return .get
        case .insertIngredient(_, _):
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .fetchOurCafe(_, _), .fetchMyCafeDrink(_), .insertIngredient(_, _):
            return .requestPlain
        case .fetchRecipe(_, let request):
            let param = request.toDictionary() ?? [:]
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        }
    }
    var headers: [String : String]? {
        nil
    }
    
    var authorizationType: AuthorizationType? {
        .bearer
    }
}
