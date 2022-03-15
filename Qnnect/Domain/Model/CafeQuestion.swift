//
//  CafeQuestion.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/15.
//

import Foundation

struct CafeQuestion {
    let comments: [Comment]
    let question: Question
    let currentUserComment: Comment?
    let liked: Bool
    let scraped: Bool
}
