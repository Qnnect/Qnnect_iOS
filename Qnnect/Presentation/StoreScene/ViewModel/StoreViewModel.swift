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
    }
    
    struct Output{
        let showIngredientBuyAlert: Signal<Void>
    }
    
    private weak var coordinator: StoreCoordinator?
    
    init(coordinator: StoreCoordinator) {
        self.coordinator = coordinator
    }
    func transform(from input: Input) -> Output {
        
        let showIngredientBuyAlert = input.didTapIngredient
            .debug()
            .do(onNext: self.showIngredientBuyAlertView(with:))
            .mapToVoid()
    
        return Output(
            showIngredientBuyAlert: showIngredientBuyAlert.asSignal(onErrorSignalWith: .empty())
        )
    }
}

private extension StoreViewModel {
    func showIngredientBuyAlertView(with ingredient: Ingredient)  {
        guard let coordinator = self.coordinator else { return }
        return coordinator.showIngredientBuyAlertView(with: ingredient)
    }
}
