//
//  CommentViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/14.
//

import Foundation
import RxSwift
import RxCocoa

final class CommentViewModel: ViewModelType {
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    private weak var coordinator: CafeCoordinator?
    private let commentUseCase: CommentUseCase
    
    init(
        coordinator: CafeCoordinator,
        commentUseCase: CommentUseCase
    ) {
        self.commentUseCase = commentUseCase
        self.coordinator = coordinator
    }
    
    func transform(from input: Input) -> Output {
        
        return Output()
    }
}
