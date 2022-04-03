//
//  CafeNetwrokService.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/06.
//

import Foundation
import Moya
import RxSwift

enum JoinCafeError: Int, Error {
    case alreadyIn = 500
    case notExisted = 401
    case isFull = 406
    case defaultError
    
    var meessage: String {
        switch self {
        case .alreadyIn:
            return "카페에 들어갈 수 없습니다."
        case .notExisted:
            return "존재하지 않는 카페 코드입니다."
        case .isFull:
            return "카페가 이미 다 찼어요!\n5명까지 카페 참여가 가능합니다."
        case .defaultError:
            return ""
        }
    }
}

final class CafeNetworkService: BaseNetworkService<CafeAPI> {
    
    func createCafe(request: CafeCreateRequestDTO) -> Observable<Result<Int,Error>> {
        return self.request(.createCafe(request: request))
            .filter(statusCode: 200)
            .map(Int.self)
           // .map(CafeCreateResponseDTO.self)
            .map{ Result.success($0)}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
    
    func fetchCafe(forId id: Int) -> Observable<Result<CafeResponseDTO,Error>> {
        return self.request(.fetchCafe(id: id))
            .filter(statusCode: 200)
            .map(CafeResponseDTO.self)
            .map{ Result.success($0)}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
    
    func updateCafe(fotId id: Int, request: CafeUpdateRequestDTO) -> Observable<Void> {
        return self.request(.updateCafe(id: id, request: request))
            .filter(statusCode: 200)
            .asObservable()
            .mapToVoid()
    }
    
    func leaveCafe(request: CafeLeaveRequestDTO) -> Observable<Result<Void,Error>> {
        return self.request(.leaveCafe(reqeust: request))
            .filter(statusCodes: 200...300)
            .map { _ in Result.success(())}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
    
    func createQuestion(cafeId: Int, request: QuestionCreateRequestDTO) -> Observable<Result<Void,Error>> {
        return self.request(.createQuestion(id: cafeId, request: request))
            .filter(statusCodes: 200...300)
            .map { _ in Result.success(())}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
    
    func joinCafe(request: CafeJoinRequestDTO) -> Observable<Result<CafeResponseDTO,JoinCafeError>> {
        return self.request(.joinCafe(request: request))
            .filter(statusCode: 200)
            .map(CafeResponseDTO.self)
            .map{ Result.success($0)}
            .catch{ .just(Result.failure(
                JoinCafeError(rawValue:($0 as? MoyaError)?.response?.statusCode ?? -1) ?? .defaultError
            ))}
            .asObservable()
            .debug()
    }
}
