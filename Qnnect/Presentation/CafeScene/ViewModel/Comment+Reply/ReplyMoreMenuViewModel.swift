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
        let replyId: Observable<Int>
        let commentId: Observable<Int>
        let didTapModifyButton: Observable<Void>
        let didTapDeleteButton: Observable<Void>
        let didTapDeleteAlertOkButton: Observable<Void>
    }
    
    struct Output {
        let delete: Signal<Void>
        let modify: Signal<Void>
        let showDeleteAlertView: Signal<Void>
    }
    
    private let commentUseCase: CommentUseCase
    
    init(commentUseCase: CommentUseCase) {
        self.commentUseCase = commentUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let showDeleteAlertView = input.didTapDeleteButton
        
        let ids = Observable.combineLatest(input.commentId, input.replyId,
                                           resultSelector: { (commentId: $0, replyId: $1)})
        
        let delete = input.didTapDeleteAlertOkButton
            .withLatestFrom(ids)
            .flatMap(commentUseCase.deleteReply)
            .compactMap { result -> Void? in
                guard case .success(_) = result else { return nil }
                return Void()
            }
        
        return Output(
            delete: delete.asSignal(onErrorSignalWith: .empty()),
            modify: .empty(),
            showDeleteAlertView: showDeleteAlertView.asSignal(onErrorSignalWith: .empty())
        )
    }
}
