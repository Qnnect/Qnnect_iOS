//
//  OurCafeNetworkService.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/17.
//

import Foundation
import Moya
import RxSwift

final class OurCafeNetworkService: BaseNetworkService<OurCafeAPI> {
    
    func fetchOurCafe(cafeId: Int, cafeUserId: Int) -> Observable<Result<OurCafeFetchResponseDTO,Error>> {
        request(.fetchOurCafe(cafeId: cafeId, cafeUserId: cafeUserId))
            .filter(statusCode: 200)
            .map(OurCafeFetchResponseDTO.self)
            .map{ Result.success($0)}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
    
    func fetchMyCafeDrink(_ cafeId: Int) -> Observable<Result<MyCafeDrinkFetchResponseDTO,Error>> {
        request(.fetchMyCafeDrink(cafeId: cafeId))
            .filter(statusCode: 200)
            .map(MyCafeDrinkFetchResponseDTO.self)
            .map{ Result.success($0)}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
}
