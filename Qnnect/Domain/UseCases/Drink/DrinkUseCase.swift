//
//  DrinkUseCase.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/11.
//

import Foundation
import RxSwift

protocol DrinkUseCase: AnyObject {
    func fetchDrinks() -> Observable<Result<[Drink],Error>>
    func selectDrink(_ cafeId: Int, _ drinkId: Int) -> Observable<Result<Void,Error>>
}

final class DefaultDrinkUseCase: DrinkUseCase {
    
    private let drinkRepository: DrinkRepository
    
    init(drinkRepository: DrinkRepository) {
        self.drinkRepository = drinkRepository
    }
    
    func fetchDrinks() -> Observable<Result<[Drink], Error>> {
        self.drinkRepository.fetchDrinks()
    }
    
    func selectDrink(_ cafeId: Int, _ drinkId: Int) -> Observable<Result<Void, Error>> {
        drinkRepository.selectDrink(cafeId, drinkId)
    }
}
