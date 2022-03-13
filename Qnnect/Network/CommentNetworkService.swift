//
//  CommentNetworkService.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/14.
//

import Foundation
import RxSwift
import Moya

final class CommentNetworkService: BaseNetworkService<CommentAPI> {
    
    func createComment(
        _ cafeId: Int,
        _ questionId: Int,
        _ images: [Data],
        _ content: String
    ) -> Observable<Result<Void,Error>> {
        request(.createComment(cafeId: cafeId, questionId: questionId, images: images, content: content))
            .filter(statusCodes: 200...300)
            .map { _ in Result.success(())}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
}
