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
        _ questionId: Int,
        _ images: [Data],
        _ content: String
    ) -> Observable<Result<Void,Error>> {
        request(.createComment(questionId: questionId, images: images, content: content))
            .filter(statusCodes: 200...300)
            .map { _ in Result.success(())}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
    
    func fetchComment(_ commentId: Int) -> Observable<Result<CommentFetchResponseDTO,Error>> {
        request(.fetchComment(commentId: commentId))
            .filter(statusCode: 200)
            .map(CommentFetchResponseDTO.self)
            .map{ Result.success($0)}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
    
    func deleteComment(_ commentId: Int) -> Observable<Result<Void,Error>> {
        request(.deleteComment(commentId: commentId))
            .filter(statusCodes: 200...300)
            .map { _ in Result.success(())}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
}
