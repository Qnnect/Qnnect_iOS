//
//  CommentMoreMenuViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/16.
//

import Foundation
import RxSwift
import RxCocoa

enum CommentMoreMenuItem {
    case delete
    case modify
}

final class CommentMoreMenuViewModel: ViewModelType {
    
    struct Input {
        let comment: Observable<Comment>
        let question: Observable<Question>
        let didTapDeleteButton: Observable<Void>
        let didTapModifyButton: Observable<Void>
        let didTapDeleteAlertOkButton: Observable<Void>
    }
    
    struct Output {
        let delete: Signal<Void>
        let modify: Signal<Void>
        let showDeleteAlertView: Signal<Void>
        let showWriteCommentScene: Signal<(Question,Comment)>
    }
    
    private let commentUseCase: CommentUseCase
    
    init(commentUseCase: CommentUseCase) {
        self.commentUseCase = commentUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let delete = input.didTapDeleteAlertOkButton
            .withLatestFrom(input.comment.map { $0.id} )
            .flatMap(commentUseCase.deleteComment(_:))
            .compactMap { result -> Void? in
                guard case .success(_) = result else { return nil }
                return Void()
            }

        let showDeleteAlertview = input.didTapDeleteButton
            
        let showWriteCommentScene = input.didTapModifyButton
            .withLatestFrom(
                Observable.combineLatest(
                    input.question,
                    input.comment
                )
            )
            
        return Output(
            delete: delete.asSignal(onErrorSignalWith: .empty()),
            modify: .empty(),
            showDeleteAlertView: showDeleteAlertview.asSignal(onErrorSignalWith: .empty()),
            showWriteCommentScene: showWriteCommentScene.asSignal(onErrorSignalWith: .empty())
        )
    }
}
