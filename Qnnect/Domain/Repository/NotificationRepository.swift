//
//  NotificationRepository.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/29.
//

import Foundation
import RxSwift

protocol NotificationRepository: AnyObject {
    func fetchNotifications(page: Int, size: Int) -> Observable<Result<[NotificationInfo],Error>>
    func readNotification(_ notificationId: Int) -> Observable<Result<Void,Error>>
    func storeDeviceToken(_ deviceToken: String) -> Observable<Result<Void,Error>>
}
