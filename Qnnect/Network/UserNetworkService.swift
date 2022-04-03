//
//  UserNetworkService.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/02.
//

import Foundation
import RxSwift
import Moya

final class UserNetworkService: BaseNetworkService<UserAPI> {
        
    func setProfile(request: ProfileRequestDTO) -> Observable<Result<ProfileResponseDTO,Error>>{
        return self.request(.setProfile(request: request))
            .filter(statusCode: 200)
            .map(ProfileResponseDTO.self)
            .map{ Result.success($0)}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
    
    func setEnableNotification(request: SetEnableNotificationRequestDTO) -> Observable<Void> {
        return self.request(.setEnableNotification(request: request))
            .filter(statusCode: 200)
            .asObservable()
            .mapToVoid()
    }
    
    func fetchUser() -> Observable<Result<FetchUserResponseDTO,Error>>{
        return self.request(.fetchUser(()))
            .filter(statusCode: 200)
            .map(FetchUserResponseDTO.self)
            .map{ Result.success($0)}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
    
    func setDefaultImage() -> Observable<Result<Void,Error>> {
        request(.setDefaultImage)
            .filter(statusCodes: 200 ... 300)
            .map{ _ in Result.success(())}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
    
    func fetchStamps() -> Observable<Result<[StampResponseDTO],Error>> {
        request(.fetchStamps)
            .filter(statusCode: 200)
            .map([StampResponseDTO].self)
            .map{ Result.success($0) }
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
    
    func fetchIsEnableNotification() -> Observable<Result<Bool,Error>> {
        request(.fetchIsEnableNotification)
            .filterSuccessfulStatusCodes()
            .map(Bool.self)
            .map{ Result.success($0) }
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
}
