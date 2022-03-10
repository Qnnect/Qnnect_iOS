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
        return self.request(.scrap(request: request))
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
}
