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

final class WriteCommentViewModel: ViewModelType {
    
    struct Input {
        let content: Observable<String>
        let didTapAttachingImageButton: Observable<Void>
        let didTapCompletionButton: Observable<[Data?]>
        let cafeQuestionId: Observable<Int>
        let type: Observable<WriteCommentType>
        let comment: Observable<Comment?>
    }
    
    struct Output {
        let isInputCompleted: Driver<Bool>
        let showImagePickerView: Signal<Void>
        let completion: Signal<Void>
        let question: Driver<Question>
        let createError: Signal<CommentCreateError>
    }
    
    private let commentUseCase: CommentUseCase
    
    init(
        commentUseCase: CommentUseCase
    ) {
        self.commentUseCase = commentUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let isInputCompleted = input.content
            .map { $0.count >= 10 }
        
        let completionTrigger = input.didTapCompletionButton
            .share()
        
        let create = completionTrigger
            .withLatestFrom(input.type, resultSelector: { (ImageDatas: $0, writeCommentYype: $1)})
            .filter{ $0.writeCommentYype == WriteCommentType.create }
            .map { $0.ImageDatas }
            .debug()
            .withLatestFrom(
                Observable.combineLatest(
                    input.cafeQuestionId,
                    input.content
                ),
                resultSelector: { ($1.0, $0, $1.1) })
            .flatMap(commentUseCase.createComment)
            .share()
        
        let createSuccess = create.compactMap{
            result -> Void? in
            guard case .success(_) = result else { return nil }
            return Void()
        }
        
        let createError = create.compactMap { result -> CommentCreateError? in
            guard case let .failure(error) = result else { return nil }
            return error
        }
        
        let modify = completionTrigger
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
        
        let completion = Observable.merge(createSuccess,modify)
            .mapToVoid()
        
        let question = input.cafeQuestionId
            .flatMap(commentUseCase.fetchQuestionSimpleInfo(_:))
            .compactMap { result -> Question? in
                guard case let .success(question) = result else { return nil }
                return question
            }
        
        return Output(
            isInputCompleted: isInputCompleted.asDriver(onErrorJustReturn: false),
            showImagePickerView: input.didTapAttachingImageButton.asSignal(onErrorSignalWith: .empty()),
            completion: completion.asSignal(onErrorSignalWith: .empty()),
            question: question.asDriver(onErrorDriveWith: .empty()),
            createError: createError.asSignal(onErrorSignalWith: .empty())
        )
    }
}
