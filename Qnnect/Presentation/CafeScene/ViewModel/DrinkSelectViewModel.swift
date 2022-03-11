//
//  SelectDrinkViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/07.
//

import Foundation
import RxSwift
import RxCocoa

final class DrinkSelctViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let drinks: Driver<[Drink]>
    }
    
    private weak var coordinator: CafeCoordinator?
    private let drinkUseCase: DrinkUseCase
    
    init(
        coordinator: CafeCoordinator,
        drinkUseCase: DrinkUseCase
    ) {
        self.coordinator = coordinator
        self.drinkUseCase = drinkUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let fetchedDrinks = input.viewDidLoad
            .flatMap(self.drinkUseCase.fetchDrinks)
            .compactMap {
                result -> [Drink]? in
                guard case let .success(drinks) = result else { return nil }
                return drinks
            }
        
        return Output(
            drinks: fetchedDrinks.asDriver(onErrorJustReturn: [])
        )
    }
}

