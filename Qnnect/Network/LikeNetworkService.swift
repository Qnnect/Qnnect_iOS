//
//  LikeNetworkService.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/15.
//

import Foundation
import Moya
import RxSwift

final class LikeNetworkService: BaseNetworkService<LikeAPI> {
    
    func like(_ questionId: Int, _ request: LikeRequestDTO) -> Observable<Result<Void,Error>> {
        self.request(.like(questionId: questionId, request: request))
            .filter(statusCodes: 200 ... 300)
            .map{ _ in Result.success(())}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
}
