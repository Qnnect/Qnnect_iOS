//
//  ReplyMoreMenuViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/16.
//

import Foundation
import RxSwift
import RxCocoa

final class ReplyMoreMenuViewModel: ViewModelType {
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    private weak var coordinator: CommentCoordinator?
    private let commentUseCase: CommentUseCase
    
    init(
        coordinator: CommentCoordinator,
        commentUseCase: CommentUseCase
    ) {
        self.coordinator = coordinator
        self.commentUseCase = commentUseCase
    }
    
    func transform(from input: Input) -> Output {
        return Output()
    }
}
