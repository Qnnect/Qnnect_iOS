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
    private let questionNetworkService: QuestionNetworkService
    
    init(
        commentNetworkService: CommentNetworkService,
        replyNetworkService: ReplyNetworkService,
        questionNetworkService: QuestionNetworkService
    ) {
        self.commentNetworkService = commentNetworkService
        self.replyNetworkService = replyNetworkService
        self.questionNetworkService = questionNetworkService
    }
    
    func createComment(
        _ questionId: Int,
        _ images: [Data],
        _ content: String
    ) -> Observable<Result<Void,Error>> {
        commentNetworkService.createComment(questionId, images, content)
    }
    
    func fetchComment(_ commentId: Int) -> Observable<
        Result<(comment: Comment, replies: [Reply], cafeQuestionId: Int),Error>
    > {
        commentNetworkService.fetchComment(commentId)
            .map {
                result -> Result<(comment: Comment, replies: [Reply], cafeQuestionId: Int),Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.toDomain())
                case .failure(let error):
                    return .failure(error)
                }
            }
    }

    func deleteComment(_ commentId: Int) -> Observable<Result<Void,Error>> {
        commentNetworkService.deleteComment(commentId)
    }
    
    func modifyComment(_ commentId: Int, _ images: [Data], _ content: String) -> Observable<Result<Void,Error>> {
        commentNetworkService.modifyComment(commentId, images, content)
    }
    
    func createReply(_ commentId: Int, _ content: String) -> Observable<Result<Void,Error>> {
        replyNetworkService.createReply(commentId, content)
    }

    func deleteReply(_ commentId: Int, _ replyId: Int) -> Observable<Result<Void, Error>> {
        replyNetworkService.deleteReply(commentId, replyId)
    }
    
    func modifyReply(_ commentId: Int, _ replyId: Int, _ content: String) -> Observable<Result<Void, Error>> {
        replyNetworkService.modifyReply(commentId, replyId, content)
    }
    
    func fetchQuestionSimpleInfo(_ cafeQuestionId: Int) -> Observable<Result<Question, Error>> {
        questionNetworkService.fetchQuestionSimpleInfo(cafeQuestionId)
            .map {
                result -> Result<Question,Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.toDomain())
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
}
