//
//  CafeAnswerViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/08.
//

import Foundation
import RxSwift
import RxCocoa

final class CafeAnswerViewModel: ViewModelType {
    
    struct Input {
        let didTapAnswerWritingCell: Observable<Void>
        /// Bool: true: 스크랩하기 , false: 스크랩 취소하기
        let didTapScrapButton: Observable<Bool>
        let questionId: Observable<Int>
        let viewWillAppear: Observable<Void>
        let didTapAnswerCell: Observable<Comment>
    }
    
    struct Output {
        let showAnswerWritingScene: Signal<Void>
        let scrap: Signal<Void>
        let cancleScrap: Signal<Void>
        let comments: Driver<[Comment]>
        let question: Driver<Question>
        let showCommentScene: Signal<Void>
        let user: Driver<User>
        let currentUserComment: Driver<Comment?>
    }
    
    private weak var coordinator: CafeCoordinator?
    private let questionUseCase: QuestionUseCase
    private let userUseCase: UserUseCase
    
    init(
        coordinator: CafeCoordinator,
        questionUseCase: QuestionUseCase,
        userUseCase: UserUseCase
    ) {
        self.coordinator = coordinator
        self.questionUseCase = questionUseCase
        self.userUseCase = userUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let fetchedQuestionWithComments = input.viewWillAppear
            .withLatestFrom(input.questionId)
            .flatMap(questionUseCase.fetchQuestion(_:))
            .debug("fetchedQuestionwithComments", trimOutput: true)
            .compactMap { result -> CafeQuestion? in
                guard case let .success(cafeQuestion) = result else { return nil }
                return cafeQuestion
            }
            .share()
            .debug()
        
        let user = input.viewWillAppear
            .flatMap(userUseCase.fetchUser)
            .compactMap{
                result -> User? in
                guard case let .success(user) = result else { return nil}
                return user
            }
        
        let fetchedQuestion = fetchedQuestionWithComments.map { $0.question }
        let liked = fetchedQuestionWithComments.map { $0.liked }
        let scraped = fetchedQuestionWithComments.map { $0.scraped }
        let currentUserComment = fetchedQuestionWithComments.map { $0.currentUserComment }
        
        let showAnswerWritingScene = input.didTapAnswerWritingCell
            .withLatestFrom(Observable.combineLatest(fetchedQuestion, user))
            .do {
                [weak self] question, user in
                self?.coordinator?.showCafeAnswerWritingScene(question, user)
            }
            .mapToVoid()
        
        let scrap = input.didTapScrapButton
            .filter { $0 }
            .withLatestFrom(fetchedQuestion.map{ $0.id })
            .flatMap(self.questionUseCase.scrap)
            .compactMap {
                result -> Void? in
                guard case .success(_) = result else { return nil }
                return Void()
            }
        
        let cancleScrap = input.didTapScrapButton
            .filter{ !$0 }
            .withLatestFrom(fetchedQuestion.map{ $0.id })
            .flatMap(self.questionUseCase.cancleScrap)
            .compactMap {
                 result -> Void? in
                guard case .success(_) = result else { return nil }
                return Void()
            }
        
        let showCommentScene = input.didTapAnswerCell
            .do {
                [weak self] comment in
                self?.coordinator?.showCommentScene(comment.id)
            }.mapToVoid()
        
        return Output(
            showAnswerWritingScene: showAnswerWritingScene.asSignal(onErrorSignalWith: .empty()),
            scrap: Observable.merge(
                scrap,
                scraped.filter{ $0 }.mapToVoid()
            ).asSignal(onErrorSignalWith: .empty()),
            cancleScrap: cancleScrap.asSignal(onErrorSignalWith: .empty()),
            comments: fetchedQuestionWithComments.map { $0.comments }.asDriver(onErrorJustReturn: []),
            question: fetchedQuestionWithComments.map { $0.question }.asDriver(onErrorDriveWith: .empty()),
            showCommentScene: showCommentScene.asSignal(onErrorSignalWith: .empty()),
            user: user.asDriver(onErrorDriveWith: .empty()),
            currentUserComment: currentUserComment.asDriver(onErrorDriveWith: .empty())
        )
    }
}
