//
//  QuestionType.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/06.
//

import Foundation

//가족, 공통, 친구, 커플
enum QuestionType: String,Codable {
    case family = "가족"
    case common = "공통"
    case friend = "친구"
    case couple = "커플"
}
