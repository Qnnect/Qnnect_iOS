//
//  HomeResponseDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/07.
//

import Foundation

struct HomeInfoResponseDTO: Decodable {
    let cafeMainResponseList: [HomeInfoCafeResponseDTO]
    let questionTodayList: [HomeInfoQuestionResponseDTO?]
    let user: FetchUserResponseDTO
    let hasUnreadNotification: Bool
    
    func toDomain() -> HomeInfo {
        return HomeInfo(
            cafes: self.cafeMainResponseList.map { $0.toDomain() },
            questions: self.questionTodayList.map { $0?.toDomain() ?? ToDayQuestion(cafeQuestionId: 0, cafeTitle: "null", content: "null", daysLeft: 7)},
            user: self.user.toDomain(),
            hasUnreadNotification: hasUnreadNotification
        )
    }
}

struct HomeInfoCafeResponseDTO: Decodable {
    let cafeUserNum: Int
    let createdAt: String
    let diaryColor: DiaryColorType
    let id: Int
    let title: String
    
    func toDomain() -> MyCafe {
        return MyCafe(
            cafeUserNum: self.cafeUserNum,
            createdAt: self.createdAt.replacingOccurrences(of: "-", with: "."),
            id: self.id,
            diaryColor: self.diaryColor,
            title: self.title
        )
    }
}

struct HomeInfoQuestionResponseDTO: Decodable {
    let cafeQuestionId: Int
    let cafeTitle: String
    let content: String
    let daysLeft: Int
    
    func toDomain() -> ToDayQuestion {
        return ToDayQuestion(
            cafeQuestionId: self.cafeQuestionId,
            cafeTitle: self.cafeTitle,
            content: self.content,
            daysLeft: self.daysLeft
        )
    }
}
