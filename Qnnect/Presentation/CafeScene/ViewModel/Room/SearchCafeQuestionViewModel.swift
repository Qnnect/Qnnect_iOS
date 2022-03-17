//
//  SearchCafeQuestionViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/16.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchCafeQuestionViewModel: ViewModelType {
    
    struct Input {
        let cafeId: Observable<Int>
        let searchWord: Observable<String>
        let moreFetch: Observable<Int>
        let didTapQuestionCell: Observable<QuestionShortInfo>
    }
    
    struct Output {
        let searchResult: Driver<[QuestionShortInfo]>
        ///Int: QuestionId
        let showCafeQuestionScene: Signal<Int>
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
            .withLatestFrom(input.cafeId, resultSelector: { (searchWork: $0, cafeId: $1)})
            .map { (cafeId: $1, page: 0,size: Constants.scrapFetchSize, searchWord: $0) }
            .flatMap(questionUseCase.searchCafeQuestion)
            .compactMap {
                result -> [QuestionShortInfo]? in
                guard case let .success(questions) = result else { return nil}
                return questions
            }
            .map { QuestionsFetchAction.load(questions: $0)}
        
        let loadMore = input.moreFetch
            .withLatestFrom(
                Observable.combineLatest(
                    input.cafeId,
                    input.searchWord,
                    resultSelector: { (cafeId: $0, searchWord: $1) }
                ),resultSelector: { (cafeId: $1.cafeId, page:$0 , searchWork: $1.searchWord)}
            )
            .map { (cafeId:$0, page: $1, size: 10, searchWord: $2)}
            .flatMap(questionUseCase.searchCafeQuestion)
            .compactMap {
                result -> [QuestionShortInfo]? in
                guard case let .success(questions) = result else { return nil}
                return questions
            }
            .map { QuestionsFetchAction.loadMore(questions: $0)}
        
        let searchResult = Observable.merge(load,loadMore)
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
        
        let showCafeQuestionScene = input.didTapQuestionCell
            .map { $0.cafeQuestionId }
        
        return Output(
            searchResult: searchResult.asDriver(onErrorDriveWith: .empty()),
            showCafeQuestionScene: showCafeQuestionScene.asSignal(onErrorSignalWith: .empty()),
            canLoad: canLoad.asSignal(onErrorSignalWith: .empty())
        )
    }
}
