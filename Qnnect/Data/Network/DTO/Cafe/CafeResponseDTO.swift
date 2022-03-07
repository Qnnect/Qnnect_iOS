//
//  CafeCreateResponseDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/05.
//

import Foundation

struct CafeResponseDTO: Decodable {
    let cafeQuestionResponseList: [CafeQuestionResponseDTO]
    let cafeUserResponseList: [CafeUserResponseDTO]
    let code: String
    let createdAt: String
    let currentUserResponse: CafeUserResponseDTO
    let organizer: Bool
    let title: String
    
    func toDomain() -> Cafe {
        return Cafe(
            questions: self.cafeQuestionResponseList.map { $0.toDomain() },
            cafeUsers: self.cafeUserResponseList.map { $0.toDomain()},
            code: self.code,
            createdAt: self.createdAt,
            currentUser: self.currentUserResponse.toDomain(),
            organizer: self.organizer,
            title: self.title
        )
    }
}
