//
//  QuestionNetworkService.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/14.
//

import Foundation
import Moya
import RxSwift

final class QuestionNetworkService: BaseNetworkService<QuestionAPI> {
    
    func fetchQuestion(_ questionId: Int) -> Observable<Result<QuestionFetchResponseDTO,Error>> {
        request(.fetchQuestion(questionId: questionId))
            .filter(statusCode: 200)
            .map(QuestionFetchResponseDTO.self)
            .map{ Result.success($0)}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
    
    func modifyQuestion(_ questionId: Int, _ content: String) -> Observable<Result<Void,Error>> {
        request(.modifyQuestion(questionId: questionId, content: content))
            .filter(statusCodes: 200 ... 300)
            .map{ _ in Result.success(())}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
    
    func deleteQuestion(_ questionId: Int) -> Observable<Result<Void,Error>> {
        request(.deleteQuestion(questionId: questionId))
            .filter(statusCodes: 200 ... 300)
            .map{ _ in Result.success(())}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
    
    func fetchCafeQuestions(_ cafeId: Int, _ request: CafeQuestionsFetchRequestDTO)
    -> Observable<Result<CafeQuestionsResponseDTO,Error>> {
        self.request(.fetchCafeQuestions(cafeId: cafeId, request: request))
            .filter(statusCode: 200)
            .map(CafeQuestionsResponseDTO.self)
            .map{ Result.success($0)}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
    
    func searchCafeQuestion(_ cafeId: Int, _ request: CafeQuestionSearchRequestDTO)
    -> Observable<Result<CafeQuestionsResponseDTO,Error>> {
        self.request(.searchCafeQuestion(cafeId: cafeId, request: request))
            .filter(statusCode: 200)
            .map(CafeQuestionsResponseDTO.self)
            .map{ Result.success($0)}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
}
