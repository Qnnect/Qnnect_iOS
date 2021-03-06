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
    
    func fetchAllScrap(_ page: Int, _ size: Int) -> Observable<Result<[QuestionShortInfo], Error>> {
        let request = ScrapFetchRequestDTO(page: page, size: size)
        
        return scrapNetworkService.fetchAllScrap(request: request)
            .map {
                result -> Result<[QuestionShortInfo],Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.map{$0.toDomain()})
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
    func fetchScrap(_ cafeId: Int, _ page: Int, _ size: Int) -> Observable<Result<[QuestionShortInfo], Error>> {
        let request = ScrapFetchRequestDTO(page: page, size: size)
        
        return scrapNetworkService.fetchScrap(cafeId, request)
            .map {
                result -> Result<[QuestionShortInfo],Error> in
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
    
    func searchScrap(_ page: Int, _ size: Int, _ searchWord: String) -> Observable<Result<[QuestionShortInfo], Error>> {
        let request = ScrapSearchRequestDTO(page: page, size: size, searchWord: searchWord)
        return scrapNetworkService.searchScrap(request: request)
            .map {
                result -> Result<[QuestionShortInfo],Error> in
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
    
    func modifyQuestion(_ questionId: Int, _ content: String) -> Observable<Result<Void,Error>> {
        questionNetworkService.modifyQuestion(questionId, content)
    }
    
    func deleteQuestion(_ questionId: Int) -> Observable<Result<Void,Error>> {
        questionNetworkService.deleteQuestion(questionId)
    }
    
    func fetchCafeQuestions(cafeId: Int, page: Int, size: Int) -> Observable<Result<[QuestionShortInfo],Error>> {
        let request = CafeQuestionsFetchRequestDTO(page: page, size: size)
        return questionNetworkService.fetchCafeQuestions(cafeId, request)
            .map {
                result -> Result<[QuestionShortInfo],Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.toDomain())
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    func searchCafeQuestion(cafeId: Int, page: Int, size: Int, _ searchWord: String) -> Observable<Result<[QuestionShortInfo],Error>> {
        let request = CafeQuestionSearchRequestDTO(page: page, size: size, searchWord: searchWord)
        return questionNetworkService.searchCafeQuestion(cafeId, request)
            .map {
                result -> Result<[QuestionShortInfo],Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.toDomain())
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
    func fetchAllUserQuestion(page: Int, size: Int) -> Observable<Result<[UserQuestion], Error>> {
        let request = CafeQuestionsFetchRequestDTO(page: page, size: size)
        return questionNetworkService.fetchAllUserQuestion(request: request)
            .map {
                result -> Result<[UserQuestion],Error> in
                switch result {
                case .success(let responseDTOs):
                    return .success(responseDTOs.map{$0.toDomain()})
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
    func fetchUserQuestions(cafeId: Int, page: Int, size: Int) -> Observable<Result<[UserQuestion], Error>> {
        let request = CafeQuestionsFetchRequestDTO(page: page, size: size)
        return questionNetworkService.fetchUserQuestions(cafeId,request: request)
            .map {
                result -> Result<[UserQuestion],Error> in
                switch result {
                case .success(let responseDTOs):
                    return .success(responseDTOs.map{ $0.toDomain()})
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
    func modifyUserQuestion(_ questionId: Int, _ content: String) -> Observable<Result<Void,Error>> {
        let request = ModifyUserQuestionRequestDTO(content: content)
        return questionNetworkService.modifyUserQuestion(questionId, request)
    }
    
    func deleteUserQuestion(_ questionId: Int) -> Observable<Result<Void,Error>> {
        questionNetworkService.deleteUserQuestion(questionId)
    }
}
