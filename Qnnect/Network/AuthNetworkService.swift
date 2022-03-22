//
//  AuthNetworkService.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/27.
//

import Foundation
import Moya
import RxSwift

final class AuthNetworkService: BaseNetworkService<AuthAPI> {
    
    func login(request: LoginRequestDTO) -> Observable<Result<LoginResponseDTO, LoginError>> {
        return self.request(.login(request: request))
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
    
    func reissueToken(request: ReissueRequestDTO) -> Observable<Result<ReissueResponseDTO, Error>> {
        return self.request(.reissue(request: request))
            .filter(statusCode: 200)
            .map(ReissueResponseDTO.self)
            .do { print("Reissue Token !!! \($0)")}
            .map{ Result.success($0)}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
    
    func logout() -> Observable<Result<Void,Error>> {
        request(.logout)
            .filter(statusCodes: 200...300)
            .map { _ in Result.success(())}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
    
    func withdraw() -> Observable<Result<Void,Error>> {
        request(.withdrawl)
            .filter(statusCodes: 200...300)
            .map { _ in Result.success(())}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
}
