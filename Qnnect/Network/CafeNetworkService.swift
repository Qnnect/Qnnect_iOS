//
//  CafeNetwrokService.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/06.
//

import Foundation
import RxSwift

final class CafeNetworkService: BaseNetworkService<CafeAPI> {
    
    func createCafe(request: CafeCreateRequestDTO) -> Observable<Result<Int,Error>> {
        return self.request(.createCafe(request: request))
            .filter(statusCode: 200)
            .map(Int.self)
           // .map(CafeCreateResponseDTO.self)
            .map{ Result.success($0)}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
    
    func fetchCafe(forId id: Int) -> Observable<Result<CafeResponseDTO,Error>> {
        return self.request(.fetchCafe(id: id))
            .filter(statusCode: 200)
            .map(CafeResponseDTO.self)
            .map{ Result.success($0)}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
    
    func updateCafe(fotId id: Int, request: CafeUpdateRequestDTO) -> Observable<Void> {
        return self.request(.updateCafe(id: id, request: request))
            .filter(statusCode: 200)
            .asObservable()
            .mapToVoid()
    }
}
