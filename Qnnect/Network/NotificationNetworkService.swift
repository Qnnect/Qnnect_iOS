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
}
