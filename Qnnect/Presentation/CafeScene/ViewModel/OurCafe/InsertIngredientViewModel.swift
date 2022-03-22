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
        let didTapRecipeButton: Observable<Void>
        let didTapStoreButton: Observable<Void>
        let didTapFullViewButton: Observable<Void>
        let didTapIngredientCell: Observable<MyIngredient>
    }
    
    struct Output {
        let ingredients: Driver<[MyIngredient]>
        let cafeDrink: Driver<CafeDrink>
        let userDrinkInfoWithStep: Driver<(curStep: DrinkStep, drink: DrinkType)>
        let drinkState: Driver<[(target: Int, filled: Int)]>
        let showRecipeScene: Signal<(cafeId: Int, userDrinkSelectedId: Int)>
        let showStoreScene: Signal<Void>
        let showIngredientStorageScene: Signal<Void>
        let showWrongStepAlertView: Signal<InsertWrongType>
        let showRightStepAlertView: Signal<(ingredient: MyIngredient,userDrinkSelectedId: Int)>
        let showCompleteDrinkScene: Signal<(DrinkStep, DrinkType)>
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
        
        let curStepWithCompletion = myCafeDrinkWithIngredients.map { $0.cafeDrink }
            .map(ourCafeUseCase.getCurStepWithCafeDrink(_:))
            .compactMap { $0?.curStep }
            .scan(into: (DrinkStep.ice, false)) { lastState, newStep in
                if lastState.0 != newStep, lastState.0 == .topping, newStep == .completed {
                    lastState = (newStep, true)
                } else {
                    lastState = (newStep, false)
                }
            }
        
        let userDrinkInfoWithStep = myCafeDrinkWithIngredients
            .map { $0.cafeDrink }
            .compactMap (ourCafeUseCase.getCurStepWithCafeDrink)
        
        let curStep = userDrinkInfoWithStep.compactMap { $0.curStep }
        
        let drinkCompletion = curStepWithCompletion.map { $0.1 }
            .filter{ $0 }
        
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
        
        let showRecipeScene = input.didTapRecipeButton
            .withLatestFrom(
                Observable.combineLatest(
                    input.cafeId,
                    myCafeDrinkWithIngredients.compactMap { $0.cafeDrink.userDrinkSelectedId },
                    resultSelector: { (cafeId: $0, userDrinkSelectedId: $1)}
                )
            )
        
        let showRightStepAlertView = input.didTapIngredientCell
            .withLatestFrom(curStep, resultSelector: { (ingredient: $0, curStep: $1 )})
            .filter {
                [weak self] ingredient, curStep in
                if (self?.ourCafeUseCase.isRightIngredientBuy(ingredient, curStep: curStep)) != nil {
                    return false
                } else {
                    return true
                }
            }
            .map { $0.ingredient }
            .withLatestFrom(myCafeDrinkWithIngredients.compactMap{ $0.cafeDrink.userDrinkSelectedId },
                            resultSelector: { (ingredient: $0, userDrinkSelectedId: $1)})
        
        
        let showWrongStepAlertView = input.didTapIngredientCell
            .withLatestFrom(curStep, resultSelector: { (ingredient: $0, curStep: $1 )})
            .compactMap(ourCafeUseCase.isRightIngredientBuy)

        
        let showCompleteDrinkScene = drinkCompletion
            .mapToVoid()
            .withLatestFrom(
                Observable.zip(
                    curStep,
                    myCafeDrinkWithIngredients.compactMap { $0.cafeDrink.userDrink }
                )
            )
        
        return Output(
            ingredients: myCafeDrinkWithIngredients.map { $0.ingredients}.asDriver(onErrorJustReturn: []) ,
            cafeDrink: myCafeDrinkWithIngredients.map { $0.cafeDrink}.asDriver(onErrorDriveWith: .empty()),
            userDrinkInfoWithStep: userDrinkInfoWithStep.asDriver(onErrorDriveWith: .empty()),
            drinkState: drinkState.asDriver(onErrorJustReturn: []),
            showRecipeScene: showRecipeScene.asSignal(onErrorSignalWith: .empty()),
            showStoreScene: input.didTapStoreButton.asSignal(onErrorSignalWith: .empty()),
            showIngredientStorageScene: input.didTapFullViewButton.asSignal(onErrorSignalWith: .empty()),
            showWrongStepAlertView: showWrongStepAlertView.asSignal(onErrorSignalWith: .empty()),
            showRightStepAlertView: showRightStepAlertView.asSignal(onErrorSignalWith: .empty()),
            showCompleteDrinkScene: showCompleteDrinkScene.asSignal(onErrorSignalWith: .empty())
        )
    }
}
