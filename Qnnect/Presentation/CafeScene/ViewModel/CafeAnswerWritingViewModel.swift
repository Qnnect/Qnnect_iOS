//
//  CafeAnswerWritingViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/09.
//

import Foundation
import RxSwift
import RxCocoa

final class CafeAnswerWritingViewModel: ViewModelType {
    
    struct Input {
        let content: Observable<String>
        let didTapAttachingImageButton: Observable<Void>
        let didTapCompletionButton: Observable<[Data?]>
        let cafeId: Observable<Int>
        let question: Observable<Question>
    }
    
    struct Output {
        let isInputCompleted: Driver<Bool>
        let showImagePickerView: Signal<Void>
        let completion: Signal<Void>
    }
    
    private weak var coordinator: CafeCoordinator?
    private let commentUseCase: CommentUseCase
    
    init(
        coordinator: CafeCoordinator,
        commentUseCase: CommentUseCase
    ) {
        self.coordinator = coordinator
        self.commentUseCase = commentUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let isInputCompleted = input.content
            .map { $0.count >= 10 }
        
        
        let createComment = input.didTapCompletionButton
            .withLatestFrom(
                Observable.combineLatest(
                    input.cafeId,
                    input.question.map { $0.id },
                    input.question.map { $0.question}),
                resultSelector: { ($1.0, $1.1, $0, $1.2) })
            .flatMap(commentUseCase.createComment)
            .compactMap{
                result -> Void? in
                guard case .success(_) = result else { return nil }
                return Void()
            }
        
        return Output(
            isInputCompleted: isInputCompleted.asDriver(onErrorJustReturn: false),
            showImagePickerView: input.didTapAttachingImageButton.asSignal(onErrorSignalWith: .empty()),
            completion: createComment.asSignal(onErrorSignalWith: .empty())
        )
    }
}