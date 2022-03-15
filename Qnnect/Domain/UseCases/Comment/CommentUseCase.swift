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
        Result<(comment: Comment, replies: [Reply], isWriter: Bool),Error>
    >
    func createReply(_ commentId: Int, _ content: String) -> Observable<Result<Void,Error>>
    func deleteComment(_ commentId: Int) -> Observable<Result<Void,Error>>
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
        Result<(comment: Comment, replies: [Reply], isWriter: Bool),Error>
    > {
        commentRepository.fetchComment(commentId)
    }
    
    func createReply(_ commentId: Int, _ content: String) -> Observable<Result<Void, Error>> {
        commentRepository.createReply(commentId, content)
    }
    
    func deleteComment(_ commentId: Int) -> Observable<Result<Void,Error>> {
        commentRepository.deleteComment(commentId)
    }
}
