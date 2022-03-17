//
//  StoreRepository.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/14.
//

import Foundation
import RxSwift

protocol StoreRepository: AnyObject {
    func fetchAllIngredient() -> Observable<Result<[Ingredient],Error>>
    func fetchIngredients(_ type: IngredientType) -> Observable<Result<[Ingredient],Error>>
    func buyIngredient(_ ingredientId: Int) -> Observable<Result<Void,Error>>
    func fetchAllMeIngredient() -> Observable<Result<[MyIngredient],Error>>
    func fetchMeIngredients(_ type: IngredientType) -> Observable<Result<[MyIngredient],Error>>
}
