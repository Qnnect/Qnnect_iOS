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
        let selectedDrink: Observable<Drink>
        let didTapCompletionButton: Observable<Void>
        let cafeId: Observable<Int>
    }
    
    struct Output {
        let drinks: Driver<[Drink]>
        let completion: Signal<Void>
    }
    
    private let drinkUseCase: DrinkUseCase
    
    init(drinkUseCase: DrinkUseCase) {
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
        
        let completion = input.didTapCompletionButton
            .withLatestFrom(Observable.combineLatest(input.cafeId, input.selectedDrink.map {$0.id} ))
            .flatMap(self.drinkUseCase.selectDrink)
            .mapToVoid()
        
        return Output(
            drinks: fetchedDrinks.asDriver(onErrorJustReturn: []),
            completion: completion.asSignal(onErrorSignalWith: .empty())
        )
    }
}

