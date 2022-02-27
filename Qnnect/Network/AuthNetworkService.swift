//
//  AuthNetworkService.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/27.
//

import Foundation
import Moya
import RxSwift

final class AuthNetworkService: Networkable {
    typealias Target = AuthAPI
    let provider = makeProvider()
    
    func login(request: LoginRequestDTO) -> Observable<LoginResponseDTO> {
        return self.provider.rx.request(.login(request: request))
            .asObservable()
            .map { try JSONDecoder().decode(LoginResponseDTO.self, from: $0.data) }
            .catchAndReturn(nil)
            .compactMap{ $0 }
    }
}
