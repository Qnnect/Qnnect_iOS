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
        let viewDidLoad: Observable<Void>
        let commentId: Observable<Int>
    }
    
    struct Output {
        let comment: Driver<Comment>
        let replies: Driver<[Reply]>
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
        
        let fetchedCommentWithReplies = input.viewDidLoad
            .withLatestFrom(input.commentId)
            .flatMap(commentUseCase.fetchComment)
            .compactMap({ result -> (comment: Comment, replies: [Reply])? in
                guard case let .success(data) = result else { return nil }
                return data
            })
            .share()
        
        return Output(
            comment: fetchedCommentWithReplies.map { $0.comment}.asDriver(onErrorDriveWith: .empty()),
            replies: fetchedCommentWithReplies.map { $0.replies}.asDriver(onErrorJustReturn: [])
        )
    }
}
