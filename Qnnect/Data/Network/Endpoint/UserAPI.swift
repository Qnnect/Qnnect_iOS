//
//  UserAPI.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/02.
//

import Foundation
import Moya

enum UserAPI {
    case setProfile(request: ProfileRequestDTO)
    case setEnableNotification(request: SetEnableNotificationRequestDTO)
    case fetchUser(Void)
}

extension UserAPI: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        return APP.baseURL
    }
    
    var path: String {
        switch self {
        case .setProfile(_):
            return "api/v1/user/profile"
        case .setEnableNotification(_):
            return "api/v1/user/enablenotification"
        case .fetchUser():
            return "api/v1/user"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .setProfile(_):
            return .patch
        case .setEnableNotification(_):
            return .patch
        case .fetchUser():
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .setProfile(let request):
            let imageData = request.profilePicture
            let name = request.nickName.data(using: .utf8) ?? Data()
            var formData: [Moya.MultipartFormData] = [Moya.MultipartFormData(provider: .data(imageData), name: "profilePicture", fileName: "profilePicture", mimeType: "image/png")]
            formData.append(Moya.MultipartFormData(provider: .data(name), name: "nickName"))
            return .uploadMultipart(formData)
        case .setEnableNotification(let request):
            let param = request.toDictionary() ?? [:]
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        case .fetchUser():
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .setProfile(_):
            return [
                "Content-Type": "multipart/form-data"
               
            ]
        case .setEnableNotification(_), .fetchUser():
            return [
                "Content-Type": "application/json"
            ]
        }
    }
    
    var authorizationType: AuthorizationType? {
        return .bearer
    }
}
