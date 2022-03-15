//
//  BookmarkViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/16.
//

import Foundation
import RxSwift
import RxCocoa

enum ScrapFetchAction {
    case load(questions: [ScrapedQuestion])
    case loadMore(questions: [ScrapedQuestion])
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
        let scrapedQuestions: Driver<[ScrapedQuestion]>
        let newLoad: Signal<Void>
        let canLoad: Signal<Bool>
        let showCafeAnswerScene: Signal<Void>
        let showSearchScene: Signal<Void>
    }
    
    private weak var coordinator: BookmarkCoordinator?
    private let questionUseCase: QuestionUseCase
    
    init(
        coordinator: BookmarkCoordinator,
        questionUseCase: QuestionUseCase
    ) {
        self.coordinator = coordinator
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
                result -> [ScrapedQuestion]? in
                guard case let .success(questions) = result else { return nil }
                return questions
            }.map { ScrapFetchAction.load(questions: $0)}
        
        let loadOne = input.didTapCafeTag
            .map { (cafeId: $0.cafeId, page: 0,size: Constants.scrapFetchSize)}
            .flatMap(questionUseCase.fetchScrap)
            .compactMap {
                result -> [ScrapedQuestion]? in
                guard case let .success(questions) = result else { return nil }
                return questions
            }.map { ScrapFetchAction.load(questions: $0)}
        
        let newLoad = Observable.merge(loadAll, loadOne)
            .share()
        
        let loadMoreAll = input.moreFetch
            .withLatestFrom(input.didTapCafeTag,resultSelector: { (cafeId: $1.cafeId, page: $0)})
            .filter{ $0.cafeId == 0 }
            .map { (page: $0.page, size: Constants.scrapFetchSize) }
            .flatMap(questionUseCase.fetchAllScrap)
            .compactMap {
                result -> [ScrapedQuestion]? in
                guard case let .success(questions) = result else { return nil }
                return questions
            }.map { ScrapFetchAction.loadMore(questions: $0)}
        
        let loadMoreOne = input.moreFetch
            .withLatestFrom(input.didTapCafeTag,resultSelector: { (cafeId: $1.cafeId, page: $0)})
            .filter{ $0.cafeId != 0 }
            .map { (cafeId: $0.cafeId, page: $0.page, size: Constants.scrapFetchSize) }
            .flatMap(questionUseCase.fetchScrap)
            .compactMap {
                result -> [ScrapedQuestion]? in
                guard case let .success(questions) = result else { return nil }
                return questions
            }.map { ScrapFetchAction.loadMore(questions: $0)}
        
        let loadMore = Observable.merge(loadMoreAll, loadMoreOne)
            .share()
        
        let load = Observable.merge(newLoad, loadMore)
            .share()
        
        let scrapedQuestions = load
            .scan(into: [ScrapedQuestion]()) { questions, action in
                switch action {
                case .load(let newQuestions):
                    questions = newQuestions
                case .loadMore(let newQuestions):
                    questions += newQuestions
                }
            }
        
        let canLoad = loadMore
            .compactMap {
                action -> [ScrapedQuestion]? in
                guard case let .loadMore(questions) = action else { return nil}
                return questions
            }
            .map { $0.count == Constants.scrapFetchSize }
          
        let showCafeAnswerScene = input.didTapQuestion
            .withLatestFrom(input.didTapCafeTag,resultSelector: { (questionId:$0, cafeTag: $1)})
            .do {
                [weak self] questionId, cafeTag in
                self?.coordinator?.showCafeAnswerScene(questionId, cafeTag.cafeId)
            }
            .mapToVoid()
        
        let showSearchScene = input.didTapSearchButton
            .do {
                [weak self] _ in
                self?.coordinator?.showBookMarkSearchScene()
            }
        
        return Output(
            cafes: cafes.asDriver(onErrorJustReturn: []),
            scrapedQuestions: scrapedQuestions.asDriver(onErrorJustReturn: []),
            newLoad: newLoad.mapToVoid().asSignal(onErrorSignalWith: .empty()),
            canLoad: canLoad.asSignal(onErrorSignalWith: .empty()),
            showCafeAnswerScene: showCafeAnswerScene.asSignal(onErrorSignalWith: .empty()),
            showSearchScene: showSearchScene.asSignal(onErrorSignalWith: .empty())
        )
    }
}
