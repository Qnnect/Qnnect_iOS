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
        let success: Signal<Void>
        let error: Signal<Void>
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
        
        let dismiss = input.didTapDismissButton
            .do{
                [weak self] _ in
                self?.dismiss()
            }
        
        let buy = input.didTapBuyButton
            .map { $0.id }
            .flatMap(storeUseCase.buyIngredient(_:))
            .share()
        
        let success = buy.compactMap {
            result -> Void? in
            guard case .success(_) = result else { return nil }
            return Void()
        }.do {
            [weak self] _ in
            self?.dismiss()
        }
        
        let error = buy.compactMap {
            result -> Error? in
            guard case let .failure(error) = result else { return nil }
            return error
        }.do {
            [weak self] error in
            print(error.localizedDescription)
            self?.coordinator?.showNotBuyAlertView()
        }.mapToVoid()
        
        
        return Output(
            dismiss: dismiss.asSignal(onErrorSignalWith: .empty()),
            success: success.asSignal(onErrorSignalWith: .empty()),
            error: error.asSignal(onErrorSignalWith: .empty())
        )
    }
}

private extension IngredientBuyAlertViewModel {
    func dismiss() {
        self.coordinator?.dismissIngredientBuyAlertView()
    }
}
