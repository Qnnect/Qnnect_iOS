//
//  SelectDrinkViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/07.
//

import Foundation

final class DrinkSelctViewModel: ViewModelType {
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    private weak var coordinator: CafeCoordinator?
    
    init(
        coordinator: CafeCoordinator
    ) {
        self.coordinator = coordinator
    }
    
    func transform(from input: Input) -> Output {
        return Output()
    }
}

