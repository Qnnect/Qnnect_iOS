//
//  OurCafeUseCase.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/17.
//

import Foundation
import RxSwift

protocol OurCafeUseCase: AnyObject {
    func fetchOurCafe(cafeId: Int, cafeUserId: Int) -> Observable<Result<OurCafe, Error>>
    func getCurStep(_ drink: CafeDrink) -> DrinkStep
    func fetchMyCafeDrink(_ cafeId: Int) -> Observable<Result<(cafeDrink: CafeDrink, ingredients: [MyIngredient]), Error>>
    func fetchRecipe(_ userDrinkSelectedId: Int, _ cafeId: Int) -> Observable<Result<(cafeDrink: CafeDrink, ingredients: [RecipeIngredient]),Error>>
    func isRightIngredientBuy(_ ingredient: MyIngredient, curStep: DrinkStep) -> Bool
    func insertIngredient(_ userDrinkSelectedId: Int, _ ingredientsId: Int) -> Observable<Result<Void,Error>>
}

final class DefaultOurCafeUseCase: OurCafeUseCase {
    
    private let ourCafeRepository: OurCafeRepository
    
    init(ourCafeRepository: OurCafeRepository) {
        self.ourCafeRepository = ourCafeRepository
    }
    
    func fetchOurCafe(cafeId: Int, cafeUserId: Int) -> Observable<Result<OurCafe, Error>> {
        ourCafeRepository.fetchOurCafe(cafeId: cafeId, cafeUserId: cafeUserId)
    }
    
    func fetchMyCafeDrink(_ cafeId: Int) -> Observable<Result<(cafeDrink: CafeDrink, ingredients: [MyIngredient]), Error>> {
        ourCafeRepository.fetchMyCafeDrink(cafeId)
    }
    
    func fetchRecipe(_ userDrinkSelectedId: Int, _ cafeId: Int) -> Observable<Result<(cafeDrink: CafeDrink, ingredients: [RecipeIngredient]),Error>> {
        ourCafeRepository.fetchRecipe(userDrinkSelectedId, cafeId)
    }
    
    func getCurStep(_ drink: CafeDrink) -> DrinkStep  {
        if drink.topping == drink.toppingFilled {
            return DrinkStep.completed
        } else if drink.main == drink.mainFilled {
            return DrinkStep.topping
        } else if drink.base == drink.baseFilled {
            return DrinkStep.main
        } else if drink.ice == drink.iceFilled {
            return DrinkStep.base
        }
        return DrinkStep.ice
    }
    
    func isRightIngredientBuy(_ ingredient: MyIngredient, curStep: DrinkStep) -> Bool {
        switch ingredient.type {
        case .ice_base:
            if ingredient.name == "얼음" , curStep == .ice {
                return true
            }
            if ingredient.name != "얼음" , curStep == .base {
                return true
            }
        case .main:
            if curStep == .main {
                return true
            }
        case .topping:
            if curStep == .topping {
                return true
            }
        }
        return false
    }
    
    func insertIngredient(_ userDrinkSelectedId: Int, _ ingredientsId: Int) -> Observable<Result<Void,Error>> {
        ourCafeRepository.insertIngredient(userDrinkSelectedId, ingredientsId)
    }
}
