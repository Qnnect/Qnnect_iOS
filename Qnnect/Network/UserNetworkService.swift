//
//  UserNetworkService.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/02.
//

import Foundation
import RxSwift
import Moya

final class UserNetworkService: Networkable {
    
    typealias Target = UserAPI
    
    private let provider = makeProvider()
    
    func setProfile(request: SetProfileRequestDTO) -> Observable<Result<SetProfileResponseDTO,Error>>{
        return provider.rx.request(.setProfile(request: request))
            .filter(statusCode: 200)
            .map(SetProfileResponseDTO.self)
            .map{ Result.success($0)}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
    
    func setEnableNotification(request: SetEnableNotificationRequestDTO) -> Observable<Void> {
        return provider.rx.request(.setEnableNotification(request: request))
            .filter(statusCode: 200)
            .asObservable()
            .mapToVoid()
    }
}
