//
//  DrinkStepUseCase.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/23.
//

import Foundation

protocol DrinkStepUseCase: AnyObject {
    func getCurStepWithCafeDrink(_ drink: CafeDrink) -> (curStep: DrinkStep, drink: DrinkType)?
}

extension DrinkStepUseCase {
    func getCurStepWithCafeDrink(_ drink: CafeDrink) -> (curStep: DrinkStep, drink: DrinkType)? {
        
        guard let userDrink = drink.userDrink else { return nil }
        if drink.topping == drink.toppingFilled {
            return (DrinkStep.completed, userDrink)
        } else if drink.main == drink.mainFilled {
            return (DrinkStep.topping, userDrink)
        } else if drink.base == drink.baseFilled {
            return (DrinkStep.main, userDrink)
        } else if drink.ice == drink.iceFilled {
            return (DrinkStep.base, userDrink)
        }
        return (DrinkStep.ice, userDrink)
    }
}
