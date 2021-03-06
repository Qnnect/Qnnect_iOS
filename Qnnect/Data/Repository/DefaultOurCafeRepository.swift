//
//  DefaultOutCafeRepository.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/17.
//

import Foundation
import RxSwift

final class DefaultOurCafeRepository: OurCafeRepository {
    
    private let ourCafeNetworkService: OurCafeNetworkService
    
    init(ourCafeNetworkService: OurCafeNetworkService) {
        self.ourCafeNetworkService = ourCafeNetworkService
    }
    
    func fetchOurCafe(cafeId: Int, cafeUserId: Int) -> Observable<Result<OurCafe, Error>> {
        ourCafeNetworkService.fetchOurCafe(cafeId: cafeId, cafeUserId: cafeUserId)
            .map {
                result -> Result<OurCafe,Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.toDomain())
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
    func fetchMyCafeDrink(_ cafeId: Int) -> Observable<Result<(cafeDrink: CafeDrink, ingredients: [MyIngredient]), Error>> {
        ourCafeNetworkService.fetchMyCafeDrink(cafeId)
            .map {
                result -> Result<(cafeDrink: CafeDrink, ingredients: [MyIngredient]),Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.toDomain())
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
    func fetchRecipe(_ userDrinkSelectedId: Int, _ cafeId: Int) -> Observable<Result<(cafeDrink: CafeDrink, ingredients: [RecipeIngredient]),Error>> {
        let request = RecipeFetchRequestDTO(cafeId: cafeId)
        return ourCafeNetworkService.fetchRecipe(userDrinkSelectedId, request)
            .map {
                result -> Result<(cafeDrink: CafeDrink, ingredients: [RecipeIngredient]),Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.toDomain())
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
    func insertIngredient(_ userDrinkSelectedId: Int, _ ingredientsId: Int) -> Observable<Result<Void,IngredientError>> {
        ourCafeNetworkService.insertIngredient(userDrinkSelectedId, ingredientsId)
    }
}
