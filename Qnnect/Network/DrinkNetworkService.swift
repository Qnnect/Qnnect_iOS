//
//  DrinkNetworkService.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/11.
//

import Foundation
import Moya
import RxSwift

final class DrinkNetworkService: BaseNetworkService<DrinkAPI> {
    
    func fetchDrinks() -> Observable<Result<[DrinkFetchResponseDTO],Error>> {
        return self.request(.fetchDrinks)
            .filter(statusCode: 200)
            .map([DrinkFetchResponseDTO].self)
            .map{ Result.success($0)}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
    
    func selectDrink(_ cafeId: Int, _ request: DrinkSelectRequestDTO) -> Observable<Result<Void,Error>> {
        return self.request(.selectDrink(cafeId: cafeId, request: request))
            .filter(statusCodes: 200 ... 300)
            .map{ _ in Result.success(())}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
}
