//
//  RightStepAlertViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/18.
//

import Foundation
import RxSwift
import RxCocoa

final class RightStepAlertViewModel: ViewModelType {
    
    struct Input {
        let didTapOkButton: Observable<Void>
        let ingredientsId: Observable<Int>
        let userDrinkSelectedId: Observable<Int>
    }
    
    struct Output {
        let insert: Signal<Void>
        let insertError: Signal<String>
    }
    
    private let ourCafeUseCase: OurCafeUseCase
    
    init(ourCafeUseCase: OurCafeUseCase) {
        self.ourCafeUseCase = ourCafeUseCase
    }
    func transform(from input: Input) -> Output {
        
        let insert = input.didTapOkButton
            .withLatestFrom(
                Observable.combineLatest(
                    input.userDrinkSelectedId,
                    input.ingredientsId,
                    resultSelector: {(userDrinkSelectedId: $0, ingredientId: $1)})
            ).flatMap(ourCafeUseCase.insertIngredient)
            
        let insertError = insert.compactMap { result -> IngredientError? in
            guard case let .failure(error) = result else { return nil }
            if error == .WRONG_INGREDIENT_SAME_LEVEL {
                return error
            }
            return nil
        }
        
        return Output(
            insert: insert.mapToVoid().asSignal(onErrorSignalWith: .empty()),
            insertError: insertError.map{ $0.message }.asSignal(onErrorSignalWith: .empty())
        )
    }
}
