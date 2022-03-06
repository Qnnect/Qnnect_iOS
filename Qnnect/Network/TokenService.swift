//
//  ReissueService.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/05.
//

import Foundation
import Moya
import RxSwift

final class TokenService: Networkable {
    typealias Target = AuthAPI
    private static let provider = makeProvider()

    static func reissueToken() -> Single<Response> {
        guard let accessToken = KeyChain.read(key: Constants.accessTokenKey),
              let refreshToken = KeyChain.read(key: Constants.refreshTokenKey) else { return Single.just(Response(statusCode: 600, data: Data())) }
        let request = ReissueRequestDTO(accessToken: accessToken, refreshToken: refreshToken)
        return self.provider.rx.request(.reissue(request: request))
    }
}


