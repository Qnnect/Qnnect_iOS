//
//  StoreUseCase.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/17.
//

import Foundation
import RxSwift

protocol StoreUseCase: AnyObject {
    func fetchAllIngredient() -> Observable<Result<[Ingredient],Error>>
    func fetchIngredients(_ type: IngredientType) -> Observable<Result<[Ingredient],Error>>
    func fetchAllMeIngredient() -> Observable<Result<[MyIngredient],Error>>
    func fetchMeIngredients(_ type: IngredientType) -> Observable<Result<[MyIngredient],Error>>
    func buyIngredient(_ ingredientId: Int) -> Observable<Result<Void,Error>>
}

final class DefaultStoreUseCase: StoreUseCase {
    
    private let storeRepository: StoreRepository
    
    init(storeRepository: StoreRepository) {
        self.storeRepository = storeRepository
    }
    
    func fetchAllIngredient() -> Observable<Result<[Ingredient], Error>> {
        storeRepository.fetchAllIngredient()
    }
    
    func fetchIngredients(_ type: IngredientType) -> Observable<Result<[Ingredient], Error>> {
        storeRepository.fetchIngredients(type)
    }
    
    func fetchAllMeIngredient() -> Observable<Result<[MyIngredient], Error>> {
        storeRepository.fetchAllMeIngredient()
    }
    
    func fetchMeIngredients(_ type: IngredientType) -> Observable<Result<[MyIngredient], Error>> {
        storeRepository.fetchMeIngredients(type)
    }
    
    func buyIngredient(_ ingredientId: Int) -> Observable<Result<Void,Error>> {
        storeRepository.buyIngredient(ingredientId)
    }
}
