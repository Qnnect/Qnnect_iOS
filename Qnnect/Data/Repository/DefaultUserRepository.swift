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
    
    init(userNetworkService: UserNetworkService) {
        self.userNetworkService = userNetworkService
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
}
