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
    
    func login(request: LoginRequestDTO) -> Observable<Result<LoginResponseDTO, LoginError>> {
        return self.provider.rx.request(.login(request: request))
            .map {
                response -> Result<LoginResponseDTO, LoginError> in
                switch response.statusCode {
                case 200:
                    do {
                        let loginResponseDTO = try JSONDecoder().decode(LoginResponseDTO.self, from: response.data)
                        return .success(loginResponseDTO)
                    } catch let error {
                        print("Decoding Error 😭!!! : \(error)")
                        return .failure(LoginError.decodingError)
                    }
                case 400...500:
                    return .failure(LoginError(rawValue: response.statusCode) ?? .unknownError)
                default:
                    return .failure(.unknownError)
                }
            }.asObservable()
    }
}
