//
//  StoreViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/16.
//

import Foundation
import RxSwift
import RxCocoa

final class StoreViewModel: ViewModelType {
    
    struct Input {
        let didTapIngredient: Observable<Ingredient>
        let viewDidLoad: Observable<Void>
        let didTapIngredientTag: Observable<IngredientType>
        let didTapWholeTag: Observable<Void>
        let didTapStorageButton: Observable<Void>
    }
    
    struct Output{
        let showIngredientBuyAlert: Signal<Ingredient>
        let ingredients: Driver<[Ingredient]>
        let showIngredientStorageScene: Signal<Void>
    }
    
    private let storeUseCase: StoreUseCase
    
    init(storeUseCase: StoreUseCase) {
        self.storeUseCase = storeUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let showIngredientBuyAlert = input.didTapIngredient
            
        
        let fetchedAllIngredient = Observable.merge(
            input.viewDidLoad,
            input.didTapWholeTag
        )
            .flatMap(storeUseCase.fetchAllIngredient)
            .debug()
            .compactMap { result -> [Ingredient]? in
                guard case let .success(ingredients) = result else { return nil }
                return ingredients
            }
        
        let fetchedIngredients = input.didTapIngredientTag
            .flatMap(storeUseCase.fetchIngredients(_:))
            .compactMap { result -> [Ingredient]? in
                guard case let .success(ingredients) = result else { return nil }
                return ingredients
            }
        
        return Output(
            showIngredientBuyAlert: showIngredientBuyAlert.asSignal(onErrorSignalWith: .empty()),
            ingredients: Observable.merge(fetchedAllIngredient,fetchedIngredients).asDriver(onErrorJustReturn: []),
            showIngredientStorageScene: input.didTapStorageButton.asSignal(onErrorSignalWith: .empty())
        )
    }
}

