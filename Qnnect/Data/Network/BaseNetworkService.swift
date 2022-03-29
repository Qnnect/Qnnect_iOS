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
            .retry(when: { (error: Observable<TokenError>) in
                error.flatMap { error -> Single<Response> in
                    TokenService.reissueToken()
                }
            })
            .filterSuccessfulStatusCodes()
            .retry(2)
    }
}

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
  func handleTokenResponse() -> Single<Element> {
    return flatMap { response in
      // 토큰 재발급 받았을 때 토큰 변경함
      if let newToken = try? response.map(ReissueResponseDTO.self) {
          KeyChain.create(key: Constants.accessTokenKey, token: newToken.accessToken)
          KeyChain.create(key: Constants.refreshTokenKey, token: newToken.refreshToken)
          if let accessToken = KeyChain.read(key: Constants.accessTokenKey),
             let refreshToken = KeyChain.read(key: Constants.refreshTokenKey) {
              print("token save success 😎  access: \(accessToken), refresh: \(refreshToken)")
          }
      } else {
          print("token decode error")
      }
                    
//      if (200 ... 299) ~= response.statusCode {
//        return Single.just(response)
//      }
//
//      if var error = try? response.map(ResponseError.self) {
//        error.statusCode = response.statusCode
//        return Single.error(error)
//      }
//
//      // Its an error and can't decode error details from server, push generic message
//      let genericError = ResponseError(statusCode: response.statusCode
//                                       serverName: "unknown Server Name",
//                                       error: "unknown error",
//                                       message: "empty message")
//      return Single.error(genericError)
        return Single.just(response)
    }
  }
}
