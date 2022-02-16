//
//  BookmarkViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/16.
//

import Foundation

final class BookmarkViewModel: ViewModelType {
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    private weak var coordinator: BookmarkCoordinator?
    
    init(coordinator: BookmarkCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(from input: Input) -> Output {
        return Output()
    }
}
