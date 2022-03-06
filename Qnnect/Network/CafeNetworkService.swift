//
//  CafeNetwrokService.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/06.
//

import Foundation
import RxSwift

final class CafeNetworkService: BaseNetworkService<CafeAPI> {
    
    func createCafe(request: CafeCreateRequestDTO) -> Observable<Result<CafeCreateResponseDTO,Error>> {
        return self.request(.createCafe(request: request))
            .filter(statusCode: 200)
            .map(CafeCreateResponseDTO.self)
            .map{ Result.success($0)}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
}
