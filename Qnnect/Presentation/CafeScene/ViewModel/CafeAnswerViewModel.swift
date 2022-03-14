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
        let user: Observable<User>
        /// Bool: true: 스크랩하기 , false: 스크랩 취소하기
        let didTapScrapButton: Observable<Bool>
        let cafeId: Observable<Int>
        let questionId: Observable<Int>
        let viewWillAppear: Observable<Void>
    }
    
    struct Output {
        let showAnswerWritingScene: Signal<Void>
        let scrap: Signal<Void>
        let cancleScrap: Signal<Void>
        let comments: Driver<[Comment]>
        let question: Driver<Question>
    }
    
    private weak var coordinator: CafeCoordinator?
    private let questionUseCase: QuestionUseCase
    
    init(
        coordinator: CafeCoordinator,
        questionUseCase: QuestionUseCase
    ) {
        self.coordinator = coordinator
        self.questionUseCase = questionUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let fetchedQuestionWithComments = input.viewWillAppear
            .withLatestFrom(input.questionId)
            .flatMap(questionUseCase.fetchQuestion(_:))
            .debug("fetchedQuestionwithComments", trimOutput: true)
            .compactMap { result -> (comments: [Comment], question: Question)? in
                guard case let .success((comments, question)) = result else { return nil }
                return (comments,question)
            }
            .share()
        
        let fetchedQuestion = fetchedQuestionWithComments.map { $0.question }
            
        
        let showAnswerWritingScene = input.didTapAnswerWritingCell
            .withLatestFrom(Observable.combineLatest(fetchedQuestion, input.user, input.cafeId))
            .do {
                [weak self] question, user, cafeId in
                self?.coordinator?.showCafeAnswerWritingScene(question, user, cafeId)
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
        
        return Output(
            showAnswerWritingScene: showAnswerWritingScene.asSignal(onErrorSignalWith: .empty()),
            scrap: Observable.merge(
                scrap,
                fetchedQuestion.filter { $0.scraped }.mapToVoid()
            ).asSignal(onErrorSignalWith: .empty()),
            cancleScrap: cancleScrap.asSignal(onErrorSignalWith: .empty()),
            comments: fetchedQuestionWithComments.map { $0.comments }.asDriver(onErrorJustReturn: []),
            question: fetchedQuestionWithComments.map { $0.question }.asDriver(onErrorDriveWith: .empty())
        )
    }
}
