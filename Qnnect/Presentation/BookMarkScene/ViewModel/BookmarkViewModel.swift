//
//  BookmarkViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/16.
//

import Foundation
import RxSwift
import RxCocoa

final class BookmarkViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let cafes: Driver<[CafeTag]>
        //let scrapedQuestions: Driver<[ScrapedQuestion]>
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
//        let newScrapFetch = Observable.merge(input.viewDidLoad)
//
//        let scrapedQuestions = input.viewDidLoad
//            .map { (page: 0,size: 10)}
//            .flatMap(questionUseCase.fetchAllScrap)
//            .compactMap {
//                result -> [ScrapedQuestion]? in
//                guard case let .success(questions) = result else { return nil }
//                return questions
//            }
//
        return Output(
            cafes: cafes.asDriver(onErrorJustReturn: [])
        )
    }
}
