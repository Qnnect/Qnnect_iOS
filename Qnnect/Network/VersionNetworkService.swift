//
//  VersionNetworkService.swift
//  Qnnect
//
//  Created by 재영신 on 2022/04/03.
//

import Foundation
import Moya
import RxSwift

final class VersionNetworkService: BaseNetworkService<VersionAPI> {
    
    func checkVersion(request: VersionRequestDTO) -> Observable<Result<Bool,Error>> {
        self.request(.checkVersion(request: request))
            .filterSuccessfulStatusCodes()
            .map(Bool.self)
            .map{ Result.success($0)}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
}
