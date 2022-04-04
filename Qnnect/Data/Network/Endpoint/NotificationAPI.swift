//
//  NotificationAPI.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/29.
//

import Foundation
import Moya

enum NotificationAPI {
    case fetchNotifications(request: NotificationRequestDTO)
    case readNotification(request: ReadNotificationRequestDTO)
    case storeDeviceToken(request: StoreDeviceTokenRequestDTO)
}

extension NotificationAPI: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        APP.baseURL
    }
    
    var path: String {
        switch self {
        case .fetchNotifications(_), .readNotification(_):
            return "api/v1/notification"
        case .storeDeviceToken(_):
            return "api/v1/notification/token"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchNotifications(_):
            return .get
        case .readNotification(_):
            return .patch
        case .storeDeviceToken(_):
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .fetchNotifications(let request):
            let param = request.toDictionary() ?? [:]
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        case .readNotification(let request):
            let param = request.toDictionary() ?? [:]
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        case .storeDeviceToken(let request):
            let param = request.toDictionary() ?? [:]
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        nil
    }
    
    var authorizationType: AuthorizationType? {
        .bearer
    }
    
}
