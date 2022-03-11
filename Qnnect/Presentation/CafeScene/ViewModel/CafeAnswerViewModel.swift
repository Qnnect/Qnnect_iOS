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
        let question: Observable<Question>
        let user: Observable<User>
        /// Bool: true: 스크랩하기 , false: 스크랩 취소하기
        let didTapScrapButton: Observable<Bool>
    }
    
    struct Output {
        let showAnswerWritingScene: Signal<Void>
        let scrap: Signal<Void>
        let cancleScrap: Signal<Void>
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
        
        let showAnswerWritingScene = input.didTapAnswerWritingCell
            .withLatestFrom(Observable.combineLatest(input.question, input.user))
            .do {
                [weak self] question, user in
                self?.coordinator?.showCafeAnswerWritingScene(question, user)
            }
            .mapToVoid()
        
        let scrap = input.didTapScrapButton
            .filter { $0 }
            .withLatestFrom(input.question.map{ $0.id })
            .flatMap(self.questionUseCase.scrap)
            .compactMap {
                result -> Void? in
                guard case .success(_) = result else { return nil }
                return Void()
            }
        
        let cancleScrap = input.didTapScrapButton
            .filter{ !$0 }
            .withLatestFrom(input.question.map{ $0.id })
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
                input.question.filter { $0.scraped }.mapToVoid()
            ).asSignal(onErrorSignalWith: .empty()),
            cancleScrap: cancleScrap.asSignal(onErrorSignalWith: .empty())
        )
    }
}
