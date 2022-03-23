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
    
    func setEnableNotification(isAgreedNoti: Bool) -> Observable<Void> {
        let request = SetEnableNotificationRequestDTO(enableNotification: isAgreedNoti)
        return self.userNetworkService.setEnableNotification(request: request)
    }
    
    
    func setProfile(profileImage: Data?, name: String) -> Observable<Result<User, Error>> {
        let request = ProfileRequestDTO(profilePicture: profileImage, nickName: name)
        return self.userNetworkService.setProfile(request: request)
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
    
    func setDefaultImage() -> Observable<Result<Void,Error>> {
        userNetworkService.setDefaultImage()
    }
    
    func fetchUser() -> Observable<Result<User, Error>> {
        return self.userNetworkService.fetchUser()
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
