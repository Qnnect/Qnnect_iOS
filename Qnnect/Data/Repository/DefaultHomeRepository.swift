//
//  DefaultHomeRepository.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/07.
//

import Foundation
import RxSwift

final class DefaultHomeRepository: HomeRepository {
    
    private let homeNetworkService: HomeNetworkService
    
    init(homeNetworkService: HomeNetworkService) {
        self.homeNetworkService = homeNetworkService
    }
    
    func fetchHomeInfo() -> Observable<Result<HomeInfo,Error>> {
        self.homeNetworkService.fetchHomeInfo()
            .map {
                result -> Result<HomeInfo,Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.toDomain())
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
}
