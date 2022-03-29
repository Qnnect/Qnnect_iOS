//
//  NotificationUseCase.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/29.
//

import Foundation
import RxSwift

protocol NotificationUseCase: AnyObject {
    func fetchNotifications(page: Int, size: Int) -> Observable<Result<[NotificationInfo],Error>>
}

final class DefaultNotificationUseCase: NotificationUseCase {
    
    private let notificationRepository: NotificationRepository
    
    init(notificationRepository: NotificationRepository) {
        self.notificationRepository = notificationRepository
    }
    
    func fetchNotifications(page: Int, size: Int) -> Observable<Result<[NotificationInfo], Error>> {
        notificationRepository.fetchNotifications(page: page, size: size)
    }
}
