//
//  commentUseCase.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/14.
//

import Foundation
import RxSwift

protocol CommentUseCase: AnyObject {
    
    func createComment(
        _ questionId: Int,
        _ images: [Data?],
        _ content: String
    ) -> Observable<Result<Void,Error>>
    func fetchComment(_ commentId: Int) -> Observable<
        Result<(comment: Comment, replies: [Reply], cafeQuestionId: Int),Error>
    >
    func deleteComment(_ commentId: Int) -> Observable<Result<Void,Error>>
    func modifyComment(_ commentId: Int, _ images: [Data?], _ content: String) -> Observable<Result<Void,Error>>
    
    func createReply(_ commentId: Int, _ content: String) -> Observable<Result<Void,Error>>
    func deleteReply(_ commentId: Int, _ replyId: Int) -> Observable<Result<Void, Error>>
    func modifyReply(_ commentId: Int, _ replyId: Int, _ content: String) -> Observable<Result<Void, Error>>
}

final class DefaultCommentUseCase: CommentUseCase {
    
    private let commentRepository: CommentRepository
    
    init(commentRepository: CommentRepository) {
        self.commentRepository = commentRepository
    }
    
    func createComment(
        _ questionId: Int,
        _ images: [Data?],
        _ content: String
    ) -> Observable<Result<Void,Error>> {
        let images = images.compactMap{ $0 }
        
        return commentRepository.createComment(questionId, images, content)
    }
    
    func fetchComment(_ commentId: Int) -> Observable<
        Result<(comment: Comment, replies: [Reply], cafeQuestionId: Int),Error>
    > {
        commentRepository.fetchComment(commentId)
    }

    func deleteComment(_ commentId: Int) -> Observable<Result<Void,Error>> {
        commentRepository.deleteComment(commentId)
    }
    
    func modifyComment(_ commentId: Int, _ images: [Data?], _ content: String) -> Observable<Result<Void,Error>> {
        let images = images.compactMap{ $0 }
        
        return commentRepository.modifyComment(commentId, images, content)
    }
    
    func createReply(_ commentId: Int, _ content: String) -> Observable<Result<Void, Error>> {
        commentRepository.createReply(commentId, content)
    }

    
    func deleteReply(_ commentId: Int, _ replyId: Int) -> Observable<Result<Void, Error>> {
        commentRepository.deleteReply(commentId, replyId)
    }
    
    func modifyReply(_ commentId: Int, _ replyId: Int, _ content: String) -> Observable<Result<Void, Error>> {
        commentRepository.modifyReply(commentId, replyId, content)
    }
}
