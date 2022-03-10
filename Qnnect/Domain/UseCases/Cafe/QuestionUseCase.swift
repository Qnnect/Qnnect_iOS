//
//  QuestionUseCase.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/10.
//

import Foundation
import RxSwift

protocol QuestionUseCase: AnyObject {
    func scrap(_ questionId: Int) -> Observable<Void>
    func cancleScrap(_ questionId: Int) -> Observable<Void>
}

final class DefaultQuestionUseCase: QuestionUseCase {
    
    private let questionRepository: QuestionRepository
    
    init(questionRepository: QuestionRepository) {
        self.questionRepository = questionRepository
    }
    
    func scrap(_ questionId: Int) -> Observable<Void> {
        return self.questionRepository.scrap(questionId)
    }
    
    func cancleScrap(_ questionId: Int) -> Observable<Void> {
        return self.questionRepository.cancleScrap(questionId)
    }
}
