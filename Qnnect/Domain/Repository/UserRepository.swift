//
//  UserRepository.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/02.
//

import Foundation
import RxSwift

protocol UserRepository: AnyObject {
    func setEnableNotification(isAgreedNoti: Bool) -> Observable<Void>
    func setProfile(profileImage: Data?, name: String) -> Observable<Result<User,Error>>
    func fetchUser() -> Observable<Result<User,Error>>
    func fetchLoginType() -> LoginType?
    func setDefaultImage() -> Observable<Result<Void,Error>>
    func fetchStamps() -> Observable<Result<[Stamp],Error>>
    func fetchIsEnableNotification() -> Observable<Result<Bool,Error>>
}
