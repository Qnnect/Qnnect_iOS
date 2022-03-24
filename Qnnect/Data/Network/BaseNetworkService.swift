//
//  BaseNetworkService.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/05.
//

import Foundation
import Moya
import RxSwift

enum TokenError: Swift.Error {
    case tokenExpired
}

class BaseNetworkService<EndPoint: TargetType>: Networkable {
    typealias Target = EndPoint
    
    private let provider = makeProvider()
    
    func request(_ endPoint: EndPoint) -> Single<Response> {
        return self.provider.rx.request(endPoint)
            .flatMap {
                // 403(Unauthorized) 발생 시 자동으로 토큰을 재발급 받는다
                if $0.statusCode == 403 {
                    throw TokenError.tokenExpired
                } else {
                    return Single.just($0)
                }
            }
            .retry { (error: Observable<TokenError>) in
                error.flatMap { error -> Single<Response> in
                    TokenService.reissueToken()
                }
            }
//            .filterSuccessfulStatusCodes()
//            .retry(2)
    }
}
