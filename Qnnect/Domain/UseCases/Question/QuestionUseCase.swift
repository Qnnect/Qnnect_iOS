//
//  QuestionUseCase.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/10.
//

import Foundation
import RxSwift

protocol QuestionUseCase: AnyObject {
    func scrap(_ questionId: Int) -> Observable<Result<Void,Error>>
    func cancleScrap(_ questionId: Int) -> Observable<Result<Void,Error>>
    func fetchAllScrap(_ page: Int, size: Int) -> Observable<Result<[ScrapedQuestion],Error>>
    func fetchScrap(_ cafeId: Int, _ page: Int, size: Int) -> Observable<Result<[ScrapedQuestion],Error>>
    func fetchCafes() -> Observable<Result<[CafeTag],Error>>
}

final class DefaultQuestionUseCase: QuestionUseCase {
    
    private let questionRepository: QuestionRepository
    
    init(questionRepository: QuestionRepository) {
        self.questionRepository = questionRepository
    }
    
    func scrap(_ questionId: Int) -> Observable<Result<Void,Error>> {
        return self.questionRepository.scrap(questionId)
    }
    
    func cancleScrap(_ questionId: Int) -> Observable<Result<Void,Error>> {
        return self.questionRepository.cancleScrap(questionId)
    }
    
    func fetchAllScrap(_ page: Int, size: Int) -> Observable<Result<[ScrapedQuestion], Error>> {
        questionRepository.fetchAllScrap(page, size)
    }
    
    func fetchScrap(_ cafeId: Int, _ page: Int, size: Int) -> Observable<Result<[ScrapedQuestion], Error>> {
        questionRepository.fetchScrap(cafeId, page, size)
    }
    
    func fetchCafes() -> Observable<Result<[CafeTag], Error>> {
        questionRepository.fetchCafes()
    }
}