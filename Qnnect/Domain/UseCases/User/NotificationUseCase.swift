//
//  NotificationUseCase.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/29.
//

import Foundation
import RxSwift
import FirebaseMessaging

protocol NotificationUseCase: AnyObject {
    func fetchNotifications(page: Int, size: Int) -> Observable<Result<[NotificationInfo],Error>>
    func readNotification(_ notificationId: Int) -> Observable<Result<Void,Error>>
    func storeDeviceToken() -> Observable<Result<Void,Error>>
}

final class DefaultNotificationUseCase: NotificationUseCase {
    
    private let notificationRepository: NotificationRepository
    
    init(notificationRepository: NotificationRepository) {
        self.notificationRepository = notificationRepository
    }
    
    func fetchNotifications(page: Int, size: Int) -> Observable<Result<[NotificationInfo], Error>> {
        notificationRepository.fetchNotifications(page: page, size: size)
    }
    
    func readNotification(_ notificationId: Int) -> Observable<Result<Void, Error>> {
        notificationRepository.readNotification(notificationId)
    }
    
    func storeDeviceToken() -> Observable<Result<Void, Error>> {
        if let token =  Messaging.messaging().fcmToken {
            return notificationRepository.storeDeviceToken(token)
        } else {
            return .empty()
        }
    }
}
