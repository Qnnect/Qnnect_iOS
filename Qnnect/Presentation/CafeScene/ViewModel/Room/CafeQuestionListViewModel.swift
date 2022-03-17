//
//  CafeQuestionListViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/16.
//

import Foundation
import RxSwift
import RxCocoa


final class CafeQuestionListViewModel: ViewModelType {
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let cafeId: Observable<Int>
        let moreFetch: Observable<Int>
        let didTapQuestionCell: Observable<QuestionShortInfo>
        let didTapSearchButton: Observable<Void>
    }
    
    struct Output {
        let questions: Driver<[QuestionShortInfo]>
        let canLoad: Signal<Bool>
        ///Int: CafeQuestionId
        let showCafeQuestionScene: Signal<Int>
        ///Int: CafeId
        let showSearchCafeQuestionScene: Signal<Int>
    }
    
    private let questionUseCase: QuestionUseCase
    
    init(questionUseCase: QuestionUseCase) {
        self.questionUseCase = questionUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let load = input.viewWillAppear
            .withLatestFrom(input.cafeId)
            .map { (cafeId: $0, page: 0, size: Constants.scrapFetchSize) }
            .flatMap(questionUseCase.fetchCafeQuestions)
            .compactMap {
                result -> [QuestionShortInfo]? in
                guard case let .success(questions) = result else { return nil }
                return questions
            }.map { QuestionsFetchAction.load(questions: $0)}
        
        let loadMore = input.moreFetch
            .withLatestFrom(
                input.cafeId,
                resultSelector: {(cafeId: $1, page: $0, size: Constants.scrapFetchSize)})
            .flatMap(questionUseCase.fetchCafeQuestions)
            .compactMap {
                result -> [QuestionShortInfo]? in
                guard case let .success(questions) = result else { return nil }
                return questions
            }
            .map { QuestionsFetchAction.loadMore(questions: $0)}
        
        let fetchedQuestions = Observable.merge(load, loadMore)
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
            
        let showSearchCafeQuestionScene = input.didTapSearchButton
            .withLatestFrom(input.cafeId)
        
        return Output(
            questions: fetchedQuestions.asDriver(onErrorDriveWith: .empty()),
            canLoad: canLoad.asSignal(onErrorSignalWith: .empty()),
            showCafeQuestionScene: showCafeQuestionScene.asSignal(onErrorSignalWith: .empty()),
            showSearchCafeQuestionScene: showSearchCafeQuestionScene.asSignal(onErrorSignalWith: .empty())
        )
    }
}
