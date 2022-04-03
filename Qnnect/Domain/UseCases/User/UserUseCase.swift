//
//  UserUseCase.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/02.
//

import Foundation
import RxSwift

protocol UserUseCase: AnyObject {
    func setEnableNotification(isAgreedNoti: Bool) -> Observable<Void>
    func setProfile(profileImage: Data?, name: String) -> Observable<Result<User,Error>>
    func fetchUser() -> Observable<Result<User,Error>>
    func isModifiedName(inputName: String, originalUser: User) -> Bool
    func fetchLoginType() -> LoginType
    func setDefaultImage() -> Observable<Result<Void,Error>>
    func fetchStamps() -> Observable<Result<[Stamp],Error>>
    func fetchIsEnableNotification() -> Observable<Result<Bool,Error>>
}

final class DefaultUserUseCase: UserUseCase {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func setEnableNotification(isAgreedNoti: Bool) -> Observable<Void> {
        return self.userRepository.setEnableNotification(isAgreedNoti: isAgreedNoti)
    }
    func setProfile(profileImage: Data?, name: String) -> Observable<Result<User,Error>> {
        return self.userRepository.setProfile(profileImage: profileImage, name: name)
    }

    func fetchUser() -> Observable<Result<User, Error>> {
        return self.userRepository.fetchUser()
    }
    
    func isModifiedName(inputName: String, originalUser: User) -> Bool {
        return originalUser.name != inputName 
    }
    
    func fetchLoginType() -> LoginType {
        return self.userRepository.fetchLoginType() ?? .unknown
    }
    
    func setDefaultImage() -> Observable<Result<Void,Error>> {
        userRepository.setDefaultImage()
    }
    
    func fetchStamps() -> Observable<Result<[Stamp], Error>> {
        userRepository.fetchStamps()
    }
    
    func fetchIsEnableNotification() -> Observable<Result<Bool, Error>> {
        userRepository.fetchIsEnableNotification()
    }
}
