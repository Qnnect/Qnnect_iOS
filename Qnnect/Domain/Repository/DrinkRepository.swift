//
//  DrinkRepository.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/11.
//

import Foundation
import RxSwift

protocol DrinkRepository: AnyObject {
    func fetchDrinks() -> Observable<Result<[Drink],Error>>
    func selectDrink(_ cafeId: Int, _ drinkId: Int) -> Observable<Result<Void,Error>>
}
