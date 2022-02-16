//
//  StoreViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/16.
//

import Foundation

final class StoreViewModel: ViewModelType {
    
    struct Input {
        
    }
    
    struct Output{
        
    }
    
    private weak var coordinator: StoreCoordinator?
    
    init(coordinator: StoreCoordinator) {
        self.coordinator = coordinator
    }
    func transform(from input: Input) -> Output {
        return Output()
    }
}
