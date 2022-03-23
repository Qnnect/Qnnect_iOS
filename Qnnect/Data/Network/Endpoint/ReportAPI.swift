//
//  ReportAPI.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/23.
//

import Foundation
import Moya

enum ReportAPI {
    case report(request: ReportRequestDTO)
    case releaseReport(request: ReportRequestDTO)
    case fetchReports
}

extension ReportAPI: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        APP.baseURL
    }
    
    var path: String {
        switch self {
        case .report(_), .releaseReport(_), .fetchReports:
            return "api/v1/user/report"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .report(_):
            return .post
        case .releaseReport(_):
            return .delete
        case .fetchReports:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .report(let request), .releaseReport(let request):
            let param = request.toDictionary() ?? [:]
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        case .fetchReports:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        nil
    }
    
    var authorizationType: AuthorizationType? {
        .bearer
    }
    
    
}
