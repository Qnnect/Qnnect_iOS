//
//  Question.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/05.
//

import Foundation

//가족, 공통, 친구, 커플
enum QuestionType: String,Codable {
    case family = "가족"
    case common = "공통"
    case friend = "친구"
    case couple = "커플"
}
struct Question {
    let id: Int
    let content: String
    let questionType: QuestionType
    let questioner: String
}
