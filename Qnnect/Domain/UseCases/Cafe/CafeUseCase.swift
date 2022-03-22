//
//  CafeUseCase.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/06.
//

import Foundation
import RxSwift

protocol CafeUseCase: DrinkStepUseCase {
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
    
    func leaveCafe(_ cafeId: Int) -> Observable<Result<Void,Error>>
    func createQuestion(_ cafeId:Int, _ content: String) -> Observable<Result<Void,Error>>
    ///Int: CafeId
    func joinCafe(_ cafeCode: String) -> Observable<Result<Int,JoinCafeError>>
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
        return cafeUser.drinkInfo.userDrinkSelectedId != nil
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
    
    func leaveCafe(_ cafeId: Int) -> Observable<Result<Void, Error>> {
        return self.cafeRepository.leaveCafe(cafeId)
    }
    
    func createQuestion(_ cafeId: Int, _ content: String) -> Observable<Result<Void, Error>> {
        cafeRepository.createQuestion(cafeId, content)
    }
    
    func joinCafe(_ cafeCode: String) -> Observable<Result<Int, JoinCafeError>> {
        cafeRepository.joinCafe(cafeCode: cafeCode)
            .map {
                switch $0 {
                case .success(let cafe):
                    return .success(cafe.cafeId)
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
}
