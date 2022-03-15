//
//  BookmarkSearchViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/15.
//

import Foundation
import RxSwift
import RxCocoa

final class BookmarkSearchViewModel: ViewModelType {
    
    struct Input {
        let searchWord: Observable<String>
        let moreFetch: Observable<Int>
        let didTapQuestion: Observable<Int>
    }
    
    struct Output {
        let searchResult: Driver<[ScrapedQuestion]>
        let showCafeAnswerScene: Signal<Int>
        let canLoad: Signal<Bool>
    }
    
    private let questionUseCase: QuestionUseCase
    
    init(questionUseCase: QuestionUseCase) {
        self.questionUseCase = questionUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let load = input.searchWord
            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { (page: 0,size: 10, searchWord: $0) }
            .flatMap(questionUseCase.searchScrap)
            .compactMap {
                result -> [ScrapedQuestion]? in
                guard case let .success(questions) = result else { return nil}
                return questions
            }
            .map { ScrapFetchAction.load(questions: $0)}
        
        let loadMore = input.moreFetch
            .withLatestFrom(input.searchWord,resultSelector: { ($0,$1)})
            .map { (page: $0, size: 10, searchWord: $1)}
            .flatMap(questionUseCase.searchScrap)
            .compactMap {
                result -> [ScrapedQuestion]? in
                guard case let .success(questions) = result else { return nil}
                return questions
            }
            .map { ScrapFetchAction.loadMore(questions: $0)}
        
        let searchResult = Observable.merge(load,loadMore)
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
            
        
        return Output(
            searchResult: searchResult.asDriver(onErrorJustReturn: []),
            showCafeAnswerScene: showCafeAnswerScene.asSignal(onErrorSignalWith: .empty()),
            canLoad: canLoad.asSignal(onErrorSignalWith: .empty())
        )
    }
}
