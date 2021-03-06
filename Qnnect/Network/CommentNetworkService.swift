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
    ) -> Observable<Result<Void,CommentCreateError>> {
        request(.createComment(questionId: questionId, images: images, content: content))
            .filter(statusCodes: 200...300)
            .map { _ in Result.success(())}
            .catch{ .just(Result.failure(CommentCreateError(statusCode: ($0 as? MoyaError)?.response?.statusCode ?? 0)))}
            .asObservable()
    }
    
    func fetchComment(_ commentId: Int) -> Observable<Result<CommentFetchResponseDTO, Error>> {
        request(.fetchComment(commentId: commentId))
            .filterSuccessfulStatusCodes()
            .map(CommentFetchResponseDTO.self)
            .map{ Result.success($0)}
            .catch{ .just(Result.failure($0)) }
            .asObservable()
        
    }
    
    func deleteComment(_ commentId: Int) -> Observable<Result<Void,Error>> {
        request(.deleteComment(commentId: commentId))
            .filter(statusCodes: 200...300)
            .map { _ in Result.success(())}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
    
    func modifyComment(_ commentId: Int, _ images: [Data], _ content: String) -> Observable<Result<Void,Error>> {
        request(.modifyComment(commentId: commentId, images: images, content: content))
            .filter(statusCodes: 200...300)
            .map { _ in Result.success(())}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
}
