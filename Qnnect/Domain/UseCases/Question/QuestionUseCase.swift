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
    func fetchAllScrap(_ page: Int, size: Int) -> Observable<Result<[QuestionShortInfo],Error>>
    func fetchScrap(_ cafeId: Int, _ page: Int, size: Int) -> Observable<Result<[QuestionShortInfo],Error>>
    func fetchCafes() -> Observable<Result<[CafeTag],Error>>
    func searchScrap(_ page:Int, _ size: Int, _ searchWord: String) -> Observable<Result<[QuestionShortInfo],Error>>
    func fetchQuestion(_ questionId: Int) -> Observable<Result<CafeQuestion,Error>>
    func modifyQuestion(_ questionId: Int, _ content: String) -> Observable<Result<Void,Error>>
    func deleteQuestion(_ questionId: Int) -> Observable<Result<Void,Error>>
    func like(_ questionId: Int, _ isUserLiked: Bool) -> Observable<Result<Void,Error>>
    func fetchCafeQuestions(cafeId: Int, page: Int, size: Int) -> Observable<Result<[QuestionShortInfo],Error>>
    func searchCafeQuestion(cafeId: Int, page: Int, size: Int, _ searchWord: String) -> Observable<Result<[QuestionShortInfo],Error>>
    func fetchAllUserQuestion(page: Int, size: Int) -> Observable<Result<[QuestionShortInfo], Error>>
    func fetchUserQuestions(cafeId: Int, page: Int, size: Int) -> Observable<Result<[QuestionShortInfo], Error>>
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
    
    func fetchAllScrap(_ page: Int, size: Int) -> Observable<Result<[QuestionShortInfo], Error>> {
        questionRepository.fetchAllScrap(page, size)
    }
    
    func fetchScrap(_ cafeId: Int, _ page: Int, size: Int) -> Observable<Result<[QuestionShortInfo], Error>> {
        questionRepository.fetchScrap(cafeId, page, size)
    }
    
    func fetchCafes() -> Observable<Result<[CafeTag], Error>> {
        questionRepository.fetchCafes()
    }
    
    func fetchQuestion(_ questionId: Int) -> Observable<Result<CafeQuestion,Error>> {
        questionRepository.fetchQuestion(questionId)
    }
    
    func searchScrap(_ page: Int, _ size: Int, _ searchWord: String) -> Observable<Result<[QuestionShortInfo], Error>> {
        questionRepository.searchScrap(page, size, searchWord)
    }
    
    func like(_ questionId: Int, _ isUserLiked: Bool) -> Observable<Result<Void, Error>> {
        questionRepository.like(questionId, isUserLiked)
    }
    
    func modifyQuestion(_ questionId: Int, _ content: String) -> Observable<Result<Void,Error>> {
        questionRepository.modifyQuestion(questionId, content)
    }
    
    func deleteQuestion(_ questionId: Int) -> Observable<Result<Void,Error>> {
        questionRepository.deleteQuestion(questionId)
    }
    
    func fetchCafeQuestions(cafeId: Int, page: Int, size: Int) -> Observable<Result<[QuestionShortInfo],Error>> {
        questionRepository.fetchCafeQuestions(cafeId: cafeId, page: page, size: size)
    }
    
    func searchCafeQuestion(cafeId: Int, page: Int, size: Int, _ searchWord: String) -> Observable<Result<[QuestionShortInfo],Error>> {
        questionRepository.searchCafeQuestion(cafeId: cafeId, page: page, size: size, searchWord)
    }
    
    func fetchAllUserQuestion(page: Int, size: Int) -> Observable<Result<[QuestionShortInfo], Error>> {
        questionRepository.fetchAllUserQuestion(page: page, size: size)
    }
    
    func fetchUserQuestions(cafeId: Int, page: Int, size: Int) -> Observable<Result<[QuestionShortInfo], Error>> {
        questionRepository.fetchUserQuestions(cafeId: cafeId, page: page, size: size)
    }
}
