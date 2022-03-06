//
//  CafeCreateRequestDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/06.
//

import Foundation

struct CafeCreateRequestDTO: Encodable {
    let diaryColor: DiaryColorType
    let groupType: GroupType
    let questionCycle: QuestionCycle
    let title: String
}
