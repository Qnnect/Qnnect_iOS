//
//  UserUseCase.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/02.
//

import Foundation
import RxSwift

protocol UserUseCase: AnyObject {
    func setEnableNotification(isAgreedNoti: Bool, accessToken: String) -> Observable<Void>
    func setProfile(profileImage: Data, name: String, accessToken: String) -> Observable<Result<User,Error>>
}

final class DefaultUserUseCase: UserUseCase {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func setEnableNotification(isAgreedNoti: Bool, accessToken: String) -> Observable<Void> {
        return self.userRepository.setEnableNotification(isAgreedNoti: isAgreedNoti, accessToken: accessToken)
    }
    func setProfile(profileImage: Data, name: String, accessToken: String) -> Observable<Result<User,Error>> {
        return self.userRepository.setProfile(profileImage: profileImage, name: name, accessToken: accessToken)
    }
}
