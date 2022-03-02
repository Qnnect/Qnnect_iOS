//
//  UserAPI.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/02.
//

import Foundation
import Moya

enum UserAPI {
    case setProfile(request: SetProfileRequestDTO, accessToken: String)
    case setEnableNotification(request: SetEnableNotificationRequestDTO, accessToken: String)
}

extension UserAPI: TargetType {
    var baseURL: URL {
        return APP.baseURL
    }
    
    var path: String {
        switch self {
        case .setProfile(_,_):
            return "api/v1/user/profile"
        case .setEnableNotification(_,_):
            return "api/v1/user/enablenotification"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .setProfile(_,_):
            return .patch
        case .setEnableNotification(_,_):
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .setProfile(let request,_):
            let imageData = request.profilePicture
            let name = request.nickName.data(using: .utf8) ?? Data()
            var formData: [Moya.MultipartFormData] = [Moya.MultipartFormData(provider: .data(imageData), name: "profilePicture", fileName: "profilePicture", mimeType: "image/png")]
            formData.append(Moya.MultipartFormData(provider: .data(name), name: "nickName"))
            return .uploadMultipart(formData)
        case .setEnableNotification(let request,_):
            let param = request.toDictionary() ?? [:]
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .setProfile(_,let accessToken):
            return [
                "Content-Type": "multipart/form-data",
                "Authorization": "Bearer \(accessToken)"
            ]
        case .setEnableNotification(_,let accessToken):
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(accessToken)"
            ]
        }
    }
    
}
