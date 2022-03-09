//
//  CafeUpdateRequestDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/09.
//

import Foundation

struct CafeUpdateRequestDTO: Encodable {
    let diaryColor: DiaryColorType
    let groupType: GroupType
    let questionCycle: QuestionCycle
    let title: String
}
