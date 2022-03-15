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
        /// string: inputText
        let didTapSendButton: Observable<String>
    }
    
    struct Output {
        let comment: Driver<Comment>
        let replies: Driver<[Reply]>
        let isWriter: Driver<Bool>
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
       
        let createReply = input.didTapSendButton
            .withLatestFrom(input.commentId,resultSelector: { ($1, $0) })
            .flatMap(commentUseCase.createReply)
            .compactMap {
                result -> Void? in
                guard case .success(_) = result else { return  nil }
                return Void()
            }
        
        let fetchedCommentWithReplies = Observable.merge(input.viewDidLoad, createReply)
            .withLatestFrom(input.commentId)
            .flatMap(commentUseCase.fetchComment)
            .compactMap({ result -> (comment: Comment, replies: [Reply], isWriter: Bool)? in
                guard case let .success(data) = result else { return nil }
                return data
            })
            .share()
        
       
        
       
        
        return Output(
            comment: fetchedCommentWithReplies.map { $0.comment}.asDriver(onErrorDriveWith: .empty()),
            replies: fetchedCommentWithReplies.map { $0.replies}.asDriver(onErrorJustReturn: []),
            isWriter: fetchedCommentWithReplies.map { $0.isWriter }.asDriver(onErrorDriveWith: .empty())
        )
    }
}
