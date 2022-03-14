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
    }
    
    struct Output{
        let showIngredientBuyAlert: Signal<Void>
        let ingredients: Driver<[Ingredient]>
    }
    
    private weak var coordinator: StoreCoordinator?
    private let storeUseCase: StoreUseCase
    
    init(
        coordinator: StoreCoordinator,
        storeUseCase: StoreUseCase
    ) {
        self.coordinator = coordinator
        self.storeUseCase = storeUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let showIngredientBuyAlert = input.didTapIngredient
            .debug()
            .do {
                [weak self] ingredient in
                self?.showIngredientBuyAlertView(with: ingredient)
            }
            .mapToVoid()
        
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
            ingredients: Observable.merge(fetchedAllIngredient,fetchedIngredients).asDriver(onErrorJustReturn: [])
        )
    }
}

private extension StoreViewModel {
    func showIngredientBuyAlertView(with ingredient: Ingredient)  {
        guard let coordinator = self.coordinator else { return }
        return coordinator.showIngredientBuyAlertView(with: ingredient)
    }
}
