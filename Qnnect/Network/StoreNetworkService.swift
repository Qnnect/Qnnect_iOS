//
//  StoreNetworkService.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/14.
//

import Foundation
import Moya
import RxSwift

final class StoreNetworkService: BaseNetworkService<IngredientAPI> {
    
    func fetchAllIngredient() -> Observable<Result<[IngredientResponseDTO],Error>> {
        request(.fetchAllIngredient)
            .filter(statusCode: 200)
            .map([IngredientResponseDTO].self)
            .map{ Result.success($0)}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
    
    func fetchIngredients(_ type: IngredientType) -> Observable<Result<[IngredientResponseDTO],Error>> {
        request(.fetchIngredients(type: type))
            .filter(statusCode: 200)
            .map([IngredientResponseDTO].self)
            .map{ Result.success($0)}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
    
    func buyIngredients(_ ingredientId: Int) -> Observable<Result<Void,Error>> {
        request(.buyIngredient(ingredientsId: ingredientId))
            .filter(statusCodes: 200 ... 300)
            .map{ _ in Result.success(())}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
}
