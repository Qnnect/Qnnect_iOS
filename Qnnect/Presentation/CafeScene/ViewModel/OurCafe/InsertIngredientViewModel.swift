//
//  InsertIngredientViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/17.
//

import Foundation
import RxSwift
import RxCocoa

final class InsertIngredientViewModel: ViewModelType {
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let cafeId: Observable<Int>
    }
    
    struct Output {
        let ingredients: Driver<[MyIngredient]>
        let cafeDrink: Driver<CafeDrink>
        let curStep: Driver<DrinkStep>
        let drinkState: Driver<[(target: Int, filled: Int)]>
    }
    
    private let ourCafeUseCase: OurCafeUseCase
    
    init(ourCafeUseCase: OurCafeUseCase) {
        self.ourCafeUseCase = ourCafeUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let myCafeDrinkWithIngredients = input.viewWillAppear
            .withLatestFrom(input.cafeId)
            .flatMap(ourCafeUseCase.fetchMyCafeDrink(_:))
            .compactMap { result -> (cafeDrink: CafeDrink, ingredients: [MyIngredient])? in
                guard case let .success(data) = result else { return nil }
                return data
            }
            .share()
        
        let curStep = myCafeDrinkWithIngredients.map { $0.cafeDrink }
            .map(ourCafeUseCase.getCurStep(_:))
        
        let drinkState = myCafeDrinkWithIngredients.map { $0.cafeDrink }
            .map {
                drink -> [(target: Int, filled: Int)] in
                var drinkState = [(target: Int, filled: Int)]()
                drinkState.append((target:drink.ice, filled: drink.iceFilled))
                drinkState.append((target:drink.base, filled: drink.baseFilled))
                drinkState.append((target:drink.main, filled: drink.mainFilled))
                drinkState.append((target:drink.topping, filled: drink.toppingFilled))
                return drinkState
            }
        
        return Output(
            ingredients: myCafeDrinkWithIngredients.map { $0.ingredients}.asDriver(onErrorJustReturn: []) ,
            cafeDrink: myCafeDrinkWithIngredients.map { $0.cafeDrink}.asDriver(onErrorDriveWith: .empty()),
            curStep: curStep.asDriver(onErrorJustReturn: .ice),
            drinkState: drinkState.asDriver(onErrorJustReturn: [])
        )
    }
}
