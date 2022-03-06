//
//  ReFreshPlugin.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/05.
//

import Foundation
import Moya

struct RefreshPlugin: PluginType {
    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        guard case let .success(response) = result else { return result }
        
        // MARK: - Token refreshing
        if response.statusCode == 401 {
            let userDefaultManager = DefaultUserDefaultManager()
            guard let token = userDefaultManager.token else { return result }
            let request = ReissueRequestDTO(accessToken: token.access, refreshToken: token.refresh)
            let provider = MoyaProvider<AuthAPI>()
            provider.request(.reissue(request: request)) { result in
                
            }
        }
    }
}
