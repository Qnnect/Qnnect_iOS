//
//  DefaultUserRepository.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/02.
//

import Foundation
import RxSwift

final class DefaultUserRepositry: UserRepository {
    
    private let userNetworkService: UserNetworkService
    private let localStorage: UserDefaultManager
    
    init(
        userNetworkService: UserNetworkService,
        localStorage: UserDefaultManager
    ) {
        self.userNetworkService = userNetworkService
        self.localStorage = localStorage
    }
    
    func setEnableNotification(isAgreedNoti: Bool, accessToken: String) -> Observable<Void> {
        let request = SetEnableNotificationRequestDTO(enableNotification: isAgreedNoti)
        return self.userNetworkService.setEnableNotification(request: request, accessToken: accessToken)
    }
    
    func setProfile(profileImage: Data, name: String, accessToken: String) -> Observable<Result<User,Error>> {
        let request = SetProfileRequestDTO(profilePicture: profileImage, nickName: name)
        return self.userNetworkService.setProfile(request: request, accessToken: accessToken)
            .map {
                result -> Result<User,Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.toDomain())
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
    func setProfile(profileImage: Data, name: String) -> Observable<Result<User, Error>> {
        guard let token = self.localStorage.token else { return .empty() }
        let request = SetProfileRequestDTO(profilePicture: profileImage, nickName: name)
        return self.userNetworkService.setProfile(request: request, accessToken: token.access)
            .map {
                result -> Result<User,Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.toDomain())
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
    func fetchUser() -> Observable<Result<User, Error>> {
        guard let token = self.localStorage.token else { return .empty() }
        return self.userNetworkService.fetchUser(accessToken: token.access)
            .map {
                result -> Result<User,Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.toDomain())
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
    func fetchLoginType() -> LoginType? {
        return self.localStorage.loginType
    }
}
