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
        let viewWillAppear: Observable<Void>
        let commentId: Observable<Int>
        /// string: inputText
        let didTapSendButton: Observable<String>
        let didTapCommentMoreButton: Observable<Void>
        /// Int: replyId
        let didTapReplyMoreButton: Observable<Int>
    }
    
    struct Output {
        let comment: Driver<Comment>
        let replies: Driver<[Reply]>
        let isWriter: Driver<Bool>
        /// Int: CommentId
        let showCommentMoreMenuBottomSheet: Signal<Int>
        /// Int: ReplyId, CommentId
        let showReplyMoreMenuBottomSheet: Signal<(replyId: Int, commentId: Int)>
    }
    
    private let commentUseCase: CommentUseCase
    
    init(commentUseCase: CommentUseCase) {
        self.commentUseCase = commentUseCase
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
        
        let fetchedCommentWithReplies = Observable.merge(input.viewWillAppear, createReply)
            .withLatestFrom(input.commentId)
            .flatMap(commentUseCase.fetchComment)
            .compactMap({ result -> (comment: Comment, replies: [Reply], isWriter: Bool)? in
                guard case let .success(data) = result else { return nil }
                return data
            })
            .share()
        
        let showCommentMoreMenuBottomSheet = input.didTapCommentMoreButton
            .withLatestFrom(input.commentId)
           
        
        let showReplyMoreMenuBottomSheet = input.didTapReplyMoreButton
            .withLatestFrom(input.commentId,resultSelector: { (replyId: $0,commentId: $1) })
        
        return Output(
            comment: fetchedCommentWithReplies.map { $0.comment}.asDriver(onErrorDriveWith: .empty()),
            replies: fetchedCommentWithReplies.map { $0.replies}.asDriver(onErrorJustReturn: []),
            isWriter: fetchedCommentWithReplies.map { $0.isWriter }.asDriver(onErrorDriveWith: .empty()),
            showCommentMoreMenuBottomSheet: showCommentMoreMenuBottomSheet.asSignal(onErrorSignalWith: .empty()),
            showReplyMoreMenuBottomSheet: showReplyMoreMenuBottomSheet.asSignal(onErrorSignalWith: .empty())
        )
    }
}
