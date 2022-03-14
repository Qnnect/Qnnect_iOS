//
//  ReplyNetworkService.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/15.
//

import Foundation
import Moya
import RxSwift

final class ReplyNetworkService: BaseNetworkService<ReplyAPI> {
    
    func createReply(_ commentId: Int, _ content: String) -> Observable<Result<Void,Error>> {
        request(.createReply(commentId: commentId, content: content))
            .filter(statusCodes: 200 ... 300)
            .map{ _ in Result.success(())}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
}
