//
//  DefaultNotificationRepository.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/29.
//

import Foundation
import RxSwift

final class DefaultNotificationRepository: NotificationRepository {
    
    private let notificationNetworkService: NotificationNetworkService
    
    init(notificationNetworkService: NotificationNetworkService) {
        self.notificationNetworkService = notificationNetworkService
    }
    
    func fetchNotifications(page: Int, size: Int) -> Observable<Result<[NotificationInfo], Error>> {
        let request = NotificationRequestDTO(page: page, size: size)
        return notificationNetworkService.fetchNotifications(request: request)
            .map {
                result -> Result<[NotificationInfo],Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.map{ $0.toDomain() })
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
}
