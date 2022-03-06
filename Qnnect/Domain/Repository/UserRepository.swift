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
    func setProfile(profileImage: Data, name: String) -> Observable<Result<User,Error>>
    func fetchUser() -> Observable<Result<User,Error>>
    func fetchLoginType() -> LoginType?
}
