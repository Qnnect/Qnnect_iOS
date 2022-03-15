//
//  ScrapNetworkService.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/10.
//

import Foundation
import Moya
import RxSwift

final class ScrapNetworkService: BaseNetworkService<ScrapAPI> {
    
    func scrap(request: ScrapRequestDTO) -> Observable<Result<Void,Error>> {
        self.request(.scrap(request: request))
            .filter(statusCode: 200)
            .map { _ in Result.success(())}
            .catch{ .just(Result.failure($0))}
            .asObservable()
        
    }
    
    func cancleScrap(request: ScrapRequestDTO) -> Observable<Result<Void,Error>> {
        return self.request(.cancleScrap(request: request))
            .filter(statusCodes: 200...300)
            .map { _ in Result.success(())}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
    
    func fetchAllScrap(request: ScrapFetchRequestDTO) -> Observable<Result<[ScrapFetchResponseDTO],Error>> {
        return self.request(.fetchAllScrap(request: request))
            .filter(statusCode: 200)
            .map([ScrapFetchResponseDTO].self)
            .map { Result.success($0)}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
    
    func fetchScrap(_ cafeId: Int, _ request: ScrapFetchRequestDTO) -> Observable<Result<[ScrapFetchResponseDTO],Error>> {
        return self.request(.fetchScrap(cafeId:cafeId, request: request))
            .filter(statusCode: 200)
            .map([ScrapFetchResponseDTO].self)
            .map { Result.success($0)}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
    
    func fetchCafes() -> Observable<Result<[CafesFetchResponseDTO],Error>> {
        self.request(.fetchCafes)
            .filter(statusCode: 200)
            .map([CafesFetchResponseDTO].self)
            .map { Result.success($0)}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
    
    func searchScrap(request: ScrapSearchRequestDTO) -> Observable<Result<[ScrapFetchResponseDTO],Error>> {
        self.request(.searchScrap(request: request))
            .filter(statusCode: 200)
            .map([ScrapFetchResponseDTO].self)
            .map { Result.success($0)}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
}
