//
//  SentQuestionListViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/29.
//

import Foundation
import RxSwift
import RxCocoa

enum SentQuestionFetchAction {
    case load(questions: [UserQuestion])
    case loadMore(questions: [UserQuestion])
}

final class SentQuestionListViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let viewWillAppear: Observable<Void>
        let didTapCafeTag: Observable<CafeTag>
        /// Int: Page
        let moreFetch: Observable<Int>
        /// Int: questionId
        let didTapQuestion: Observable<UserQuestion>
    }
    
    struct Output {
        let cafes: Driver<[CafeTag]>
        let sentQuestions: Driver<[UserQuestion]>
        let newLoad: Signal<Void>
        let canLoad: Signal<Bool>
        ///Int: QuestionId
        let showCafeQuestionScene: Signal<Int>
        let showWaitingQuestionScene: Signal<UserQuestion>
    }
    
    private let questionUseCase: QuestionUseCase
    
    init(questionUseCase: QuestionUseCase) {
        self.questionUseCase = questionUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let cafes = input.viewDidLoad
            .flatMap(questionUseCase.fetchCafes)
            .compactMap {
                result -> [CafeTag]? in
                guard case let .success(cafes) = result else { return nil }
                return cafes
            }
        
        let loadAll = Observable.merge(
            input.didTapCafeTag.filter {$0.cafeId == 0}.mapToVoid(),
            input.viewWillAppear.skip(1)
            )
            .map { (page: 0,size: Constants.scrapFetchSize)}
            .flatMap(questionUseCase.fetchAllUserQuestion)
            .map {
                result -> [UserQuestion] in
                guard case let .success(questions) = result else { return [] }
                return questions
            }.map { SentQuestionFetchAction.load(questions: $0)}
        
        let loadOne = input.didTapCafeTag
            .filter {$0.cafeId != 0}
            .map { (cafeId: $0.cafeId, page: 0,size: Constants.scrapFetchSize)}
            .flatMap(questionUseCase.fetchUserQuestions)
            .map {
                result -> [UserQuestion] in
                guard case let .success(questions) = result else { return [] }
                return questions
            }.map { SentQuestionFetchAction.load(questions: $0)}
        
        let newLoad = Observable.merge(loadAll, loadOne)
            .share()
        
        let loadMoreAll = input.moreFetch
            .withLatestFrom(input.didTapCafeTag,resultSelector: { (cafeId: $1.cafeId, page: $0)})
            .filter{ $0.cafeId == 0 }
            .map { (page: $0.page, size: Constants.scrapFetchSize) }
            .flatMap(questionUseCase.fetchAllUserQuestion)
            .map {
                result -> [UserQuestion] in
                guard case let .success(questions) = result else { return [] }
                return questions
            }.map { SentQuestionFetchAction.loadMore(questions: $0)}
        
        let loadMoreOne = input.moreFetch
            .withLatestFrom(input.didTapCafeTag,resultSelector: { (cafeId: $1.cafeId, page: $0)})
            .filter{ $0.cafeId != 0 }
            .map { (cafeId: $0.cafeId, page: $0.page, size: Constants.scrapFetchSize) }
            .flatMap(questionUseCase.fetchUserQuestions)
            .map {
                result -> [UserQuestion] in
                guard case let .success(questions) = result else { return [] }
                return questions
            }.map { SentQuestionFetchAction.loadMore(questions: $0)}
        
        let loadMore = Observable.merge(loadMoreAll, loadMoreOne)
            .share()
        
        let load = Observable.merge(newLoad, loadMore)
            .share()
        
        let sentQuestions = load
            .scan(into: [UserQuestion]()) { questions, action in
                switch action {
                case .load(let newQuestions):
                    questions = newQuestions
                case .loadMore(let newQuestions):
                    questions += newQuestions
                }
            }
        
        let canLoad = loadMore
            .compactMap {
                action -> [UserQuestion]? in
                guard case let .loadMore(questions) = action else { return nil}
                return questions
            }
            .map { $0.count == Constants.scrapFetchSize }
        
        let showCafeQuestionScene = input.didTapQuestion
            .filter { !$0.waitingList }
            .map { $0.id }
        
        let showWaitingQuestionScene = input.didTapQuestion
            .filter{ $0.waitingList }
        
        return Output(
            cafes: cafes.asDriver(onErrorJustReturn: []),
            sentQuestions: sentQuestions.asDriver(onErrorJustReturn: []),
            newLoad: newLoad.mapToVoid().asSignal(onErrorSignalWith: .empty()),
            canLoad: canLoad.asSignal(onErrorSignalWith: .empty()),
            showCafeQuestionScene: showCafeQuestionScene.asSignal(onErrorSignalWith: .empty()),
            showWaitingQuestionScene: showWaitingQuestionScene.asSignal(onErrorSignalWith: .empty())
        )
    }
}
