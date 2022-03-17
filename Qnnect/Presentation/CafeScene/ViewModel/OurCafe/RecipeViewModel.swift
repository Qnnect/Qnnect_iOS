//
//  RecipeViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/18.
//

import Foundation
import RxSwift
import RxCocoa

final class RecipeViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let cafeId: Observable<Int>
        let userDrinkSelectedId: Observable<Int>
        let didTapStoreButton: Observable<Void>
    }
    
    struct Output {
        let recipe: Driver<[RecipeIngredient]>
        let cafeDrink: Driver<CafeDrink>
        let showStoreScene: Signal<Void>
    }
    
    private let ourCafeUseCase: OurCafeUseCase
    
    init(ourCafeUseCase: OurCafeUseCase) {
        self.ourCafeUseCase = ourCafeUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let recipe = input.viewDidLoad
            .withLatestFrom(
                Observable.combineLatest(
                    input.userDrinkSelectedId,
                    input.cafeId,
                    resultSelector: { (userDrinkSelectedId: $0, cafeId: $1) }
                )
            )
            .flatMap(ourCafeUseCase.fetchRecipe)
            .compactMap {
                result -> (cafeDrink: CafeDrink, ingredients: [RecipeIngredient])? in
                guard case let .success(data) = result else { return nil }
                return data
            }
            .share()
        
        
        return Output(
            recipe: recipe.map { $0.ingredients }.asDriver(onErrorJustReturn: []),
            cafeDrink: recipe.map { $0.cafeDrink }.asDriver(onErrorDriveWith: .empty()),
            showStoreScene: input.didTapStoreButton.asSignal(onErrorSignalWith: .empty())
        )
    }
}
