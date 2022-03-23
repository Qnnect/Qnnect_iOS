//
//  BookmarkViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/16.
//

import Foundation
import RxSwift
import RxCocoa

enum QuestionsFetchAction {
    case load(questions: [QuestionShortInfo])
    case loadMore(questions: [QuestionShortInfo])
}
final class BookmarkViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let didTapCafeTag: Observable<CafeTag>
        /// Int: Page
        let moreFetch: Observable<Int>
        /// Int: questionId
        let didTapQuestion: Observable<Int>
        let didTapSearchButton: Observable<Void>
    }
    
    struct Output {
        let cafes: Driver<[CafeTag]>
        let scrapedQuestions: Driver<[QuestionShortInfo]>
        let newLoad: Signal<Void>
        let canLoad: Signal<Bool>
        ///Int: QuestionId
        let showCafeQuestionScene: Signal<Int>
        let showSearchScene: Signal<Void>
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
            .flatMap(questionUseCase.fetchAllScrap)
            .compactMap {
                result -> [QuestionShortInfo]? in
                guard case let .success(questions) = result else { return nil }
                return questions
            }.map { QuestionsFetchAction.load(questions: $0)}
        
        let loadOne = input.didTapCafeTag
            .map { (cafeId: $0.cafeId, page: 0,size: Constants.scrapFetchSize)}
            .flatMap(questionUseCase.fetchScrap)
            .compactMap {
                result -> [QuestionShortInfo]? in
                guard case let .success(questions) = result else { return nil }
                return questions
            }.map { QuestionsFetchAction.load(questions: $0)}
        
        let newLoad = Observable.merge(loadAll, loadOne)
            .share()
        
        let loadMoreAll = input.moreFetch
            .withLatestFrom(input.didTapCafeTag,resultSelector: { (cafeId: $1.cafeId, page: $0)})
            .filter{ $0.cafeId == 0 }
            .map { (page: $0.page, size: Constants.scrapFetchSize) }
            .flatMap(questionUseCase.fetchAllScrap)
            .compactMap {
                result -> [QuestionShortInfo]? in
                guard case let .success(questions) = result else { return nil }
                return questions
            }.map { QuestionsFetchAction.loadMore(questions: $0)}
        
        let loadMoreOne = input.moreFetch
            .withLatestFrom(input.didTapCafeTag,resultSelector: { (cafeId: $1.cafeId, page: $0)})
            .filter{ $0.cafeId != 0 }
            .map { (cafeId: $0.cafeId, page: $0.page, size: Constants.scrapFetchSize) }
            .flatMap(questionUseCase.fetchScrap)
            .compactMap {
                result -> [QuestionShortInfo]? in
                guard case let .success(questions) = result else { return nil }
                return questions
            }.map { QuestionsFetchAction.loadMore(questions: $0)}
        
        let loadMore = Observable.merge(loadMoreAll, loadMoreOne)
            .share()
        
        let load = Observable.merge(newLoad, loadMore)
            .share()
        
        let scrapedQuestions = load
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
            
        
        let showSearchScene = input.didTapSearchButton
           
        
        return Output(
            cafes: cafes.asDriver(onErrorJustReturn: []),
            scrapedQuestions: scrapedQuestions.asDriver(onErrorDriveWith: .empty()),
            newLoad: newLoad.mapToVoid().asSignal(onErrorSignalWith: .empty()),
            canLoad: canLoad.asSignal(onErrorSignalWith: .empty()),
            showCafeQuestionScene: showCafeQuestionScene.asSignal(onErrorSignalWith: .empty()),
            showSearchScene: showSearchScene.asSignal(onErrorSignalWith: .empty())
        )
    }
}
