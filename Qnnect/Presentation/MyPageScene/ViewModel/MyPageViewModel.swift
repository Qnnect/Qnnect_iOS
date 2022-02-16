//
//  MyPageViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/16.
//

import Foundation


final class MyPageViewModel: ViewModelType {
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    private weak var coordinator: MyPageCoordinator?
    
    init(coordinator: MyPageCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(from input: Input) -> Output {
        return Output()
    }
}
