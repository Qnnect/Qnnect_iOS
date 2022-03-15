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
    private let likeNetworkService: LikeNetworkService
    
    init(
        scrapNetworkService: ScrapNetworkService,
        questionNetworkService: QuestionNetworkService,
        likeNetworkService: LikeNetworkService
    ) {
        self.scrapNetworkService = scrapNetworkService
        self.questionNetworkService = questionNetworkService
        self.likeNetworkService = likeNetworkService
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
    
    func fetchQuestion(_ questionId: Int) -> Observable<Result<CafeQuestion,Error>> {
        questionNetworkService.fetchQuestion(questionId)
            .map {
                result -> Result<CafeQuestion,Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.toDomain())
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
    func searchScrap(_ page: Int, _ size: Int, _ searchWord: String) -> Observable<Result<[ScrapedQuestion], Error>> {
        let request = ScrapSearchRequestDTO(page: page, size: size, searchWord: searchWord)
        return scrapNetworkService.searchScrap(request: request)
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
    
    func like(_ questionId: Int, _ isUserLiked: Bool) -> Observable<Result<Void, Error>> {
        let request = LikeRequestDTO(isUserLiked: isUserLiked)
        return likeNetworkService.like(questionId, request)
    }
}
