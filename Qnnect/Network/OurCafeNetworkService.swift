//
//  OurCafeNetworkService.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/17.
//

import Foundation
import Moya
import RxSwift

enum IngredientError: Int, Error {
    case WRONG_INGREDIENT_SAME_LEVEL = 406
    case defaultError = -1
    var message: String {
        switch self {
        case .WRONG_INGREDIENT_SAME_LEVEL:
            return "앗! 잘못 넣었어요.\n레시피를 한번 더 확인해보세요."
        case .defaultError:
            return "error"
        }
    }
}
final class OurCafeNetworkService: BaseNetworkService<OurCafeAPI> {
    
    func fetchOurCafe(cafeId: Int, cafeUserId: Int) -> Observable<Result<OurCafeFetchResponseDTO,Error>> {
        request(.fetchOurCafe(cafeId: cafeId, cafeUserId: cafeUserId))
            .filter(statusCode: 200)
            .map(OurCafeFetchResponseDTO.self)
            .map{ Result.success($0)}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
    
    func fetchMyCafeDrink(_ cafeId: Int) -> Observable<Result<MyCafeDrinkFetchResponseDTO,Error>> {
        request(.fetchMyCafeDrink(cafeId: cafeId))
            .filter(statusCode: 200)
            .map(MyCafeDrinkFetchResponseDTO.self)
            .map{ Result.success($0)}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
    
    func fetchRecipe(_ userDrinkSelectedId: Int, _ request: RecipeFetchRequestDTO) -> Observable<Result<CafeDrinkRecipeResponseDTO,Error>> {
        self.request(.fetchRecipe(userDrinkSelectedId: userDrinkSelectedId, request: request))
            .filter(statusCode: 200)
            .map(CafeDrinkRecipeResponseDTO.self)
            .map{ Result.success($0)}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
    
    func insertIngredient(_ userDrinkSelectedId: Int, _ ingredientsId: Int) -> Observable<Result<Void,IngredientError>> {
        request(.insertIngredient(userDrinkSelectedId: userDrinkSelectedId, ingredientsId: ingredientsId))
            .filter(statusCodes: 200 ... 300)
            .map{ _ in Result.success(())}
            .catch{ .just(Result.failure(
                IngredientError(rawValue:($0 as? MoyaError)?.response?.statusCode ?? -1) ?? .defaultError
            ))}
           
            .asObservable()
    }
}
