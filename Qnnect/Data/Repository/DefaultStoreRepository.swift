//
//  DefaultStoreRepository.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/14.
//

import Foundation
import RxSwift

final class DefaultStoreRepository: StoreRepository {
    
    private let storeNetworkService: StoreNetworkService
    
    init(storeNetworkService: StoreNetworkService) {
        self.storeNetworkService = storeNetworkService
    }
    
    func fetchAllIngredient() -> Observable<Result<[Ingredient], Error>> {
        storeNetworkService.fetchAllIngredient()
            .map {
                result -> Result<[Ingredient],Error> in
                switch result {
                case .success(let responseDTOs):
                    return .success(responseDTOs.map{ $0.toDomain()} )
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
    func fetchIngredients(_ type: IngredientType) -> Observable<Result<[Ingredient], Error>> {
        storeNetworkService.fetchIngredients(type)
            .map {
                result -> Result<[Ingredient],Error> in
                switch result {
                case .success(let responseDTOs):
                    return .success(responseDTOs.map{ $0.toDomain()} )
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
    func buyIngredient(_ ingredientId: Int) -> Observable<Result<Void,Error>> {
        storeNetworkService.buyIngredients(ingredientId)
    }
    
    func fetchAllMeIngredient() -> Observable<Result<[MyIngredient], Error>> {
        storeNetworkService.fetchAllMeIngredient()
            .map {
                result -> Result<[MyIngredient],Error> in
                switch result {
                case .success(let responseDTOs):
                    return .success(responseDTOs.map{ $0.toDomain()} )
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
    func fetchMeIngredients(_ type: IngredientType) -> Observable<Result<[MyIngredient], Error>> {
        storeNetworkService.fetchMeIngredients(type)
            .map {
                result -> Result<[MyIngredient],Error> in
                switch result {
                case .success(let responseDTOs):
                    return .success(responseDTOs.map{ $0.toDomain()} )
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
}
