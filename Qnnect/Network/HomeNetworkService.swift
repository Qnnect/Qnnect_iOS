//
//  HomeNetworkService.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/07.
//

import Foundation
import RxSwift

final class HomeNetworkService: BaseNetworkService<HomeAPI> {
    
    func fetchHomeInfo() -> Observable<Result<HomeInfoResponseDTO,Error>> {
        return self.request(.fetchHomeInfo)
            .filter(statusCode: 200)
            .map(HomeInfoResponseDTO.self)
            .map{ Result.success($0)}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
}
