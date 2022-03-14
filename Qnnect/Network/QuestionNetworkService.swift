//
//  QuestionNetworkService.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/14.
//

import Foundation
import Moya
import RxSwift

final class QuestionNetworkService: BaseNetworkService<QuestionAPI> {
    
    func fetchQuestion(_ questionId: Int) -> Observable<Result<QuestionFetchResponseDTO,Error>> {
        request(.fetchQuestion(questionId: questionId))
            .filter(statusCode: 200)
            .map(QuestionFetchResponseDTO.self)
            .map{ Result.success($0)}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
}
