//
//  AddGroupUseCase.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/22.
//

import Foundation
import RxSwift

protocol AddCafeUseCase: AnyObject {
    func isValidName(_ name: String) -> Bool
    func createRoom(
        with name: String,
        _ groupType: GroupType,
        _ diaryColor: DiaryColorType,
        _ questionCycle: QuestionCycle
    ) -> Observable<Result<Int,Error>>
}

final class DefaultAddCafeUseCase: AddCafeUseCase {

    private let cafeRepository: CafeRepository
    
    init(cafeRepository: CafeRepository) {
        self.cafeRepository = cafeRepository
    }
    
    func isValidName(_ name: String) -> Bool {
        let length = name.count
        return length >= 2 && length <= 10 ? true : false
    }
    
    func createRoom(
        with name: String,
        _ groupType: GroupType,
        _ diaryColor: DiaryColorType,
        _ questionCycle: QuestionCycle
    ) -> Observable<Result<Int,Error>> {
        return self.cafeRepository.createRoom(with: name, groupType, diaryColor, questionCycle)
    }
}
