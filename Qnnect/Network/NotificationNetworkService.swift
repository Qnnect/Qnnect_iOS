//
//  NotificationNetworkService.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/29.
//

import Foundation
import Moya
import RxSwift

final class NotificationNetworkService: BaseNetworkService<NotificationAPI> {
    
    func fetchNotifications(request: NotificationRequestDTO) -> Observable<Result<[NotificationResponseDTO],Error>> {
        self.request(.fetchNotifications(request: request))
            .filter(statusCode: 200)
            .map([NotificationResponseDTO].self)
            .map{ Result.success($0)}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
    
    func readNotification(request: ReadNotificationRequestDTO) -> Observable<Result<Void,Error>> {
        self.request(.readNotification(request: request))
            .filterSuccessfulStatusCodes()
            .map{ _ in Result.success(())}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
    
    func storeDeviceToken(request: StoreDeviceTokenRequestDTO) -> Observable<Result<Void,Error>> {
        self.request(.storeDeviceToken(request: request))
            .filterSuccessfulStatusCodes()
            .map{ _ in Result.success(())}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
}
