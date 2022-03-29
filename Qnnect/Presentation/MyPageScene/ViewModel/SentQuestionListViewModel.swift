//
//  SentQuestionListViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/29.
//

import Foundation
import RxSwift
import RxCocoa

final class SentQuestionListViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let didTapCafeTag: Observable<CafeTag>
        /// Int: Page
        let moreFetch: Observable<Int>
        /// Int: questionId
        let didTapQuestion: Observable<Int>
    }
    
    struct Output {
        let cafes: Driver<[CafeTag]>
        let sentQuestions: Driver<[QuestionShortInfo]>
        let newLoad: Signal<Void>
        let canLoad: Signal<Bool>
        ///Int: QuestionId
        let showCafeQuestionScene: Signal<Int>
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
        
        let loadAll = input.didTapCafeTag.filter {$0.cafeId == 0}.mapToVoid()
            .map { (page: 0,size: Constants.scrapFetchSize)}
            .flatMap(questionUseCase.fetchAllUserQuestion)
            .map {
                result -> [QuestionShortInfo] in
                guard case let .success(questions) = result else { return [] }
                return questions
            }.map { QuestionsFetchAction.load(questions: $0)}
        
        let loadOne = input.didTapCafeTag
            .filter {$0.cafeId != 0}
            .map { (cafeId: $0.cafeId, page: 0,size: Constants.scrapFetchSize)}
            .flatMap(questionUseCase.fetchUserQuestions)
            .map {
                result -> [QuestionShortInfo] in
                guard case let .success(questions) = result else { return [] }
                return questions
            }.map { QuestionsFetchAction.load(questions: $0)}
        
        let newLoad = Observable.merge(loadAll, loadOne)
            .share()
        
        let loadMoreAll = input.moreFetch
            .withLatestFrom(input.didTapCafeTag,resultSelector: { (cafeId: $1.cafeId, page: $0)})
            .filter{ $0.cafeId == 0 }
            .map { (page: $0.page, size: Constants.scrapFetchSize) }
            .flatMap(questionUseCase.fetchAllUserQuestion)
            .map {
                result -> [QuestionShortInfo] in
                guard case let .success(questions) = result else { return [] }
                return questions
            }.map { QuestionsFetchAction.loadMore(questions: $0)}
        
        let loadMoreOne = input.moreFetch
            .withLatestFrom(input.didTapCafeTag,resultSelector: { (cafeId: $1.cafeId, page: $0)})
            .filter{ $0.cafeId != 0 }
            .map { (cafeId: $0.cafeId, page: $0.page, size: Constants.scrapFetchSize) }
            .flatMap(questionUseCase.fetchUserQuestions)
            .map {
                result -> [QuestionShortInfo] in
                guard case let .success(questions) = result else { return [] }
                return questions
            }.map { QuestionsFetchAction.loadMore(questions: $0)}
        
        let loadMore = Observable.merge(loadMoreAll, loadMoreOne)
            .share()
        
        let load = Observable.merge(newLoad, loadMore)
            .share()
        
        let sentQuestions = load
            .scan(into: [QuestionShortInfo]()) { questions, action in
                switch action {
                case .load(let newQuestions):
                    questions = newQuestions
                case .loadMore(let newQuestions):
                    questions += newQuestions
                }
            }
        
        let canLoad = loadMore
            .compactMap {
                action -> [QuestionShortInfo]? in
                guard case let .loadMore(questions) = action else { return nil}
                return questions
            }
            .map { $0.count == Constants.scrapFetchSize }
        
        let showCafeQuestionScene = input.didTapQuestion
        
        return Output(
            cafes: cafes.asDriver(onErrorJustReturn: []),
            sentQuestions: sentQuestions.asDriver(onErrorJustReturn: []),
            newLoad: newLoad.mapToVoid().asSignal(onErrorSignalWith: .empty()),
            canLoad: canLoad.asSignal(onErrorSignalWith: .empty()),
            showCafeQuestionScene: showCafeQuestionScene.asSignal(onErrorSignalWith: .empty())
        )
    }
}
