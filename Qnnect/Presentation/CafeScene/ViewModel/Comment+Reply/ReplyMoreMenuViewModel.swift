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
        let reply: Observable<Reply>
        let commentId: Observable<Int>
        let didTapModifyButton: Observable<Void>
        let didTapDeleteButton: Observable<Void>
        let didTapDeleteAlertOkButton: Observable<Void>
    }
    
    struct Output {
        let delete: Signal<Void>
        let showDeleteAlertView: Signal<Void>
        let showModifyReplyScene: Signal<(commentId:Int, reply: Reply)>
    }
    
    private let commentUseCase: CommentUseCase
    
    init(commentUseCase: CommentUseCase) {
        self.commentUseCase = commentUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let showDeleteAlertView = input.didTapDeleteButton
        
        let ids = Observable.combineLatest(input.commentId, input.reply.map { $0.id} ,
                                           resultSelector: { (commentId: $0, replyId: $1)})
        
        let delete = input.didTapDeleteAlertOkButton
            .withLatestFrom(ids)
            .flatMap(commentUseCase.deleteReply)
            .compactMap { result -> Void? in
                guard case .success(_) = result else { return nil }
                return Void()
            }
        
        let showModifyReplyScene = input.didTapModifyButton
            .withLatestFrom(
                Observable.combineLatest(input.commentId, input.reply,resultSelector: { (commentId: $0, reply: $1)})
            )
            
        return Output(
            delete: delete.asSignal(onErrorSignalWith: .empty()),
            showDeleteAlertView: showDeleteAlertView.asSignal(onErrorSignalWith: .empty()),
            showModifyReplyScene: showModifyReplyScene.asSignal(onErrorSignalWith: .empty())
        )
    }
}
