//
//  CafeCreateResponseDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/05.
//

import Foundation

struct CafeCreateResponseDTO: Decodable {
    let cafeQuestionResponseList: [CafeQuestionResponseDTO]
    let cafeUserResponseList: [CafeUserResponseDTO]
    let code: String
    let createdAt: String
    let organizer: ProfileResponseDTO
    let title: String
}
