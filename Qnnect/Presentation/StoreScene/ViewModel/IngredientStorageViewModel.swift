//
//  IngredientStorageViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/18.
//

import Foundation
import RxSwift
import RxCocoa

final class IngredientStorageViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let didTapIngredientTag: Observable<IngredientType>
        let didTapWholeTag: Observable<Void>
    }
    
    struct Output {
        let ingredients: Driver<[MyIngredient]>
    }
    
    private let storeUseCase: StoreUseCase
    
    init(storeUseCase: StoreUseCase) {
        self.storeUseCase = storeUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let fetchedAllIngredient = Observable.merge(
            input.viewDidLoad,
            input.didTapWholeTag
        )
            .flatMap(storeUseCase.fetchAllMeIngredient)
            .debug()
            .compactMap { result -> [MyIngredient]? in
                guard case let .success(ingredients) = result else { return nil }
                return ingredients
            }
        
        let fetchedIngredients = input.didTapIngredientTag
            .flatMap(storeUseCase.fetchMeIngredients(_:))
            .compactMap { result -> [MyIngredient]? in
                guard case let .success(ingredients) = result else { return nil }
                return ingredients
            }
        
        let ingredients = Observable.merge(fetchedAllIngredient,fetchedIngredients)
        
        return Output(
            ingredients: ingredients.asDriver(onErrorJustReturn: [])
        )
    }
}
