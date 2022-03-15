//
//  DefaultCommentRepository.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/14.
//

import Foundation
import RxSwift

final class DefaultCommentRepository: CommentRepository {
    
    private let commentNetworkService: CommentNetworkService
    private let replyNetworkService: ReplyNetworkService
    init(
        commentNetworkService: CommentNetworkService,
        replyNetworkService: ReplyNetworkService
    ) {
        self.commentNetworkService = commentNetworkService
        self.replyNetworkService = replyNetworkService
    }
    
    func createComment(
        _ questionId: Int,
        _ images: [Data],
        _ content: String
    ) -> Observable<Result<Void,Error>> {
        commentNetworkService.createComment(questionId, images, content)
    }
    
    func fetchComment(_ commentId: Int) -> Observable<
        Result<(comment: Comment, replies: [Reply], isWriter: Bool),Error>
    > {
        commentNetworkService.fetchComment(commentId)
            .map {
                result -> Result<(comment: Comment, replies: [Reply], isWriter: Bool),Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.toDomain())
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
    func createReply(_ commentId: Int, _ content: String) -> Observable<Result<Void,Error>> {
        replyNetworkService.createReply(commentId, content)
    }
}
