//
//  DefaultCafeRespository.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/06.
//

import Foundation
import RxSwift

final class DefaultCafeRepository: CafeRepository {
    
    private let cafeNetworkService: CafeNetworkService
    
    init(cafeNetworkService: CafeNetworkService) {
        self.cafeNetworkService = cafeNetworkService
    }
    
    func createRoom(
        with name: String,
        _ groupType: GroupType,
        _ diaryColor: DiaryColorType,
        _ questionCycle: QuestionCycle
    ) -> Observable<Result<Int, Error>> {
        
        let request = CafeCreateRequestDTO(
            diaryColor: diaryColor,
            groupType: groupType,
            questionCycle: questionCycle,
            title: name
        )
        
        return self.cafeNetworkService.createCafe(request: request)
          
    }
    
    func fetchCafe(forId id: Int) -> Observable<Result<Cafe, Error>> {
        return self.cafeNetworkService.fetchCafe(forId: id)
            .map {
                result -> Result<Cafe,Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.toDomain())
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
    func updateCafe(
        forId id: Int,
        with name: String,
        _ groupType: GroupType,
        _ diaryColor: DiaryColorType,
        _ questionCycle: QuestionCycle
    ) -> Observable<Void> {
        let request = CafeUpdateRequestDTO(
            diaryColor: diaryColor,
            groupType: groupType,
            questionCycle: questionCycle,
            title: name
        )
        return self.cafeNetworkService.updateCafe(fotId: id, request: request)
    }
    
    func leaveCafe(_ cafeId: Int) -> Observable<Result<Void, Error>> {
        let request = CafeLeaveRequestDTO(cafeId: cafeId)
        return self.cafeNetworkService.leaveCafe(request: request)
    }
    
    func createQuestion(_ cafeId: Int, _ content: String) -> Observable<Result<Void, Error>> {
        let request = QuestionCreateRequestDTO(content: content)
        return self.cafeNetworkService.createQuestion(cafeId: cafeId, request: request)
    }
    
    func joinCafe(cafeCode: String) -> Observable<Result<Cafe, Error>> {
        let request = CafeJoinRequestDTO(cafeCode: cafeCode)
        return self.cafeNetworkService.joinCafe(request: request)
            .map {
                result -> Result<Cafe,Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.toDomain())
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
}
