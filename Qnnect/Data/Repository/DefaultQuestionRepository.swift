//
//  DefaultQuestionRepository.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/10.
//

import Foundation
import RxSwift

final class DefaultQuestionRepository: QuestionRepository {
    
    private let scrapNetworkService: ScrapNetworkService
    private let questionNetworkService: QuestionNetworkService
    
    init(
        scrapNetworkService: ScrapNetworkService,
        questionNetworkService: QuestionNetworkService
    ) {
        self.scrapNetworkService = scrapNetworkService
        self.questionNetworkService = questionNetworkService
    }
    
    func scrap(_ questionId: Int) -> Observable<Result<Void,Error>> {
        let request = ScrapRequestDTO(cafeQuestionId: questionId)
        
        return self.scrapNetworkService.scrap(request: request)
    }
    
    func cancleScrap(_ questionId: Int) -> Observable<Result<Void,Error>> {
        let request = ScrapRequestDTO(cafeQuestionId: questionId)
        
        return self.scrapNetworkService.cancleScrap(request: request)
    }
    
    func fetchAllScrap(_ page: Int, _ size: Int) -> Observable<Result<[ScrapedQuestion], Error>> {
        let request = ScrapFetchRequestDTO(page: page, size: size)
        
        return scrapNetworkService.fetchAllScrap(request: request)
            .map {
                result -> Result<[ScrapedQuestion],Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.map{$0.toDomain()})
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
    func fetchScrap(_ cafeId: Int, _ page: Int, _ size: Int) -> Observable<Result<[ScrapedQuestion], Error>> {
        let request = ScrapFetchRequestDTO(page: page, size: size)
        
        return scrapNetworkService.fetchScrap(cafeId, request)
            .map {
                result -> Result<[ScrapedQuestion],Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.map{$0.toDomain()})
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
    func fetchCafes() -> Observable<Result<[CafeTag], Error>> {
        scrapNetworkService.fetchCafes()
            .map {
                result -> Result<[CafeTag],Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.map{$0.toDomain()})
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
    func fetchQuestion(_ questionId: Int) -> Observable<Result<(comments: [Comment], question: Question), Error>> {
        questionNetworkService.fetchQuestion(questionId)
            .map {
                result -> Result<(comments: [Comment], question: Question),Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(
                        (
                            responseDTO.comments.map { $0.toDomain()},
                            responseDTO.questionMainResponse.toDomain()
                        )
                    )
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
}
