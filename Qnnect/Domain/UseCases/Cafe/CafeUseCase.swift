//
//  CafeUseCase.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/06.
//

import Foundation
import RxSwift

protocol CafeUseCase: AnyObject {
    func fetchCafe(forId id: Int) -> Observable<Result<Cafe,Error>>
    func isDrinkSelected(_ cafeUser: CafeUser) -> Bool
    func isValidName(_ name: String) -> Bool
    func createRoom(
        with name: String,
        _ groupType: GroupType,
        _ diaryColor: DiaryColorType,
        _ questionCycle: QuestionCycle
    ) -> Observable<Result<Int,Error>>

    func isCafeInfoChanged(
        inputInfo: (name:String, groupType: GroupType, colorType: DiaryColorType, cycle: QuestionCycle),
        cafe: Cafe
    ) -> Bool
    
    func updateCafe(
        forId id: Int,
        with name: String,
        _ groupType: GroupType,
        _ diaryColor: DiaryColorType,
        _ questionCycle: QuestionCycle
    ) -> Observable<Void>
}

final class DefaultCafeUseCase: CafeUseCase {
    
    private let cafeRepository: CafeRepository
    
    init(cafeRepository: CafeRepository) {
        self.cafeRepository = cafeRepository
    }
    
    func fetchCafe(forId id: Int) -> Observable<Result<Cafe, Error>> {
        self.cafeRepository.fetchCafe(forId: id)
    }
    
    func isDrinkSelected(_ cafeUser: CafeUser) -> Bool {
        return cafeUser.userDrinkSelected != nil
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

    //TODO: 기능 미구현
    func isCafeInfoChanged(
        inputInfo: (name:String, groupType: GroupType, colorType: DiaryColorType, cycle: QuestionCycle),
        cafe: Cafe
    ) -> Bool {
        return false
    }
    
    func updateCafe(
        forId id: Int,
        with name: String,
        _ groupType: GroupType,
        _ diaryColor: DiaryColorType,
        _ questionCycle: QuestionCycle
    ) -> Observable<Void> {
        return self.cafeRepository.updateCafe(
            forId: id,
            with: name,
            groupType,
            diaryColor,
            questionCycle
        )
    }
}
