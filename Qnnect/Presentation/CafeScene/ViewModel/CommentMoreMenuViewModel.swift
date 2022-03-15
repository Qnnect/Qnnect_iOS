//
//  CommentMoreMenuViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/16.
//

import Foundation
import RxSwift
import RxCocoa

final class CommentMoreMenuViewModel: ViewModelType {
    
    struct Input {
        let commentId: Observable<Int>
        let didTapDeleteButton: Observable<Void>
        let didTapModifyButton: Observable<Void>
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
        
        let delete = input.didTapDeleteAlertOkButton
            .withLatestFrom(input.commentId)
            .flatMap(commentUseCase.deleteComment(_:))
            .compactMap { result -> Void? in
                guard case .success(_) = result else { return nil }
                return Void()
            }

        let showDeleteAlertview = input.didTapDeleteButton
            
        return Output(
            delete: delete.asSignal(onErrorSignalWith: .empty()),
            modify: .empty(),
            showDeleteAlertView: showDeleteAlertview.asSignal(onErrorSignalWith: .empty())
        )
    }
}
