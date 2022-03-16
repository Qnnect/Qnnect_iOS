//
//  CafeAnswerWritingViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/09.
//

import Foundation
import RxSwift
import RxCocoa

enum WriteCommentType {
    case create
    case modify
}

final class CafeAnswerWritingViewModel: ViewModelType {
    
    struct Input {
        let content: Observable<String>
        let didTapAttachingImageButton: Observable<Void>
        let didTapCompletionButton: Observable<[Data?]>
        let question: Observable<Question>
        let type: Observable<WriteCommentType>
        let comment: Observable<Comment?>
    }
    
    struct Output {
        let isInputCompleted: Driver<Bool>
        let showImagePickerView: Signal<Void>
        let completion: Signal<Void>
    }
    
    private let commentUseCase: CommentUseCase
    
    init(commentUseCase: CommentUseCase) {
        self.commentUseCase = commentUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let isInputCompleted = input.content
            .map { $0.count >= 10 }
        
        let create = input.didTapCompletionButton
            .withLatestFrom(input.type, resultSelector: { (ImageDatas: $0, writeCommentYype: $1)})
            .filter{ $0.writeCommentYype == WriteCommentType.create }
            .map { $0.ImageDatas }
            .debug()
            .withLatestFrom(
                Observable.combineLatest(
                    input.question.map { $0.id },
                    input.content
                ),
                resultSelector: { ($1.0, $0, $1.1) })
            .flatMap(commentUseCase.createComment)
            .compactMap{
                result -> Void? in
                guard case .success(_) = result else { return nil }
                return Void()
            }
        
        let modify = input.didTapCompletionButton
            .withLatestFrom(input.type, resultSelector: { (ImageDatas: $0, writeCommentYype: $1)})
            .filter{ $0.writeCommentYype == WriteCommentType.modify }
            .map { $0.ImageDatas }
            .withLatestFrom(
                Observable.combineLatest(
                    input.comment.compactMap { $0?.id },
                    input.content
                ),
                resultSelector: { ( $1.0, $0, $1.1) })
            .flatMap(commentUseCase.modifyComment)
            .compactMap{
                result -> Void? in
                guard case .success(_) = result else { return nil }
                return Void()
            }
        
        let completion = Observable.merge(create,modify)
            .mapToVoid()
        
        return Output(
            isInputCompleted: isInputCompleted.asDriver(onErrorJustReturn: false),
            showImagePickerView: input.didTapAttachingImageButton.asSignal(onErrorSignalWith: .empty()),
            completion: completion.asSignal(onErrorSignalWith: .empty())
        )
    }
}
