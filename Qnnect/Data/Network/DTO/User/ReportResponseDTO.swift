//
//  ReportResponseDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/23.
//

import Foundation

struct ReportResponseDTO: Decodable {
    let nickname: String
    let reportId: Int
    
    func toDomain() -> ReportUser {
        ReportUser(reportId: reportId, nickName: nickname)
    }
}
