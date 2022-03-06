//
//  CafeRepository.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/06.
//

import Foundation
import RxSwift

protocol CafeRepository: AnyObject {
    func createRoom(
        with name: String,
        _ groupType: GroupType,
        _ diaryColor: DiaryColorType,
        _ questionCycle: QuestionCycle
    )  -> Observable<Result<Int,Error>>
    
    func fetchCafe(forId id: Int) -> Observable<Result<Cafe,Error>>
}