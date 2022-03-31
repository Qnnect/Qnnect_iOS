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
        let error: Signal<Void>
    }
    
    private let storeUseCase: StoreUseCase
    
    init(storeUseCase: StoreUseCase) {
        self.storeUseCase = storeUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        
          
        let buy = input.didTapBuyButton
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .map { $0.id }
            .flatMap(storeUseCase.buyIngredient(_:))
            .share()
        
        let success = buy.compactMap {
            result -> Void? in
            guard case .success(_) = result else { return nil }
            return Void()
        }
        
        let dismiss = Observable.merge(input.didTapDismissButton,success)
        
        let error = buy.compactMap {
            result -> Error? in
            guard case let .failure(error) = result else { return nil }
            return error
        }.mapToVoid()
        
        
        return Output(
            dismiss: dismiss.asSignal(onErrorSignalWith: .empty()),
            error: error.asSignal(onErrorSignalWith: .empty())
        )
    }
}

