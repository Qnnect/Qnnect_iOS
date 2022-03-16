//
//  Netwrokable.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/23.
//

import Foundation
import Moya
import NVActivityIndicatorView

protocol Networkable {
    /// provider객체 생성 시 Moya에서 제공하는 TargetType을 명시해야 하므로 타입 필요
    associatedtype Target: TargetType
    /// DIP를 위해 protocol에 provider객체를 만드는 함수 정의
    static func makeProvider() -> MoyaProvider<Target>
}

extension Networkable {

    static func makeProvider() -> MoyaProvider<Target> {
        /// 로그 세팅
        let loggerPlugin = NetworkLoggerPlugin()
       
      
        let accessTokenPlugin = AccessTokenPlugin { _ in
            return KeyChain.read(key: Constants.accessTokenKey) ?? ""
        }
      /// plugin객체를 주입하여 provider 객체 생성
        return MoyaProvider<Target>(plugins: [loggerPlugin, accessTokenPlugin])
    }

}
