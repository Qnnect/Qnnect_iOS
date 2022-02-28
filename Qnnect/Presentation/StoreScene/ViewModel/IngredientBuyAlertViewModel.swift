//
//  IngredientBuyAlertViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/28.
//

import Foundation
import RxSwift
import RxCocoa


final class IngredientBuyAlertViewModel: ViewModelType {
    
    struct Input {
        let didTapDismissButton: Observable<Void>
        let didTapBuyButton: Observable<Ingredient>
    }
    
    struct Output {
        let dismiss: Signal<Void>
    }
    
    private weak var coordinator: StoreCoordinator?
    
    init(
        coordinator: StoreCoordinator
    ) {
        self.coordinator = coordinator
    }
    
    func transform(from input: Input) -> Output {
        
        let dismiss = Observable.merge(input.didTapDismissButton,input.didTapBuyButton.mapToVoid())
            .do(onNext: self.dismiss)
                
        return Output(
            dismiss: dismiss.asSignal(onErrorSignalWith: .empty())
        )
    }
}

private extension IngredientBuyAlertViewModel {
    func dismiss() {
        self.coordinator?.dismissIngredientBuyAlertView()
    }
}
