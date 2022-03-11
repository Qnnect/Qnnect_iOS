//
//  DefaultDrinkRepository.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/11.
//

import Foundation
import RxSwift

final class DefaultDrinkRepository: DrinkRepository {
    
    private let drinkNetworkService: DrinkNetworkService
    
    init(drinkNetworkService: DrinkNetworkService) {
        self.drinkNetworkService = drinkNetworkService
    }
    
    func fetchDrinks() -> Observable<Result<[Drink], Error>> {
        self.drinkNetworkService.fetchDrinks()
            .map {
                result -> Result<[Drink],Error> in
                switch result {
                case .success(let responseDTOs):
                    return .success(responseDTOs.map{ $0.toDomain()} )
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
}
