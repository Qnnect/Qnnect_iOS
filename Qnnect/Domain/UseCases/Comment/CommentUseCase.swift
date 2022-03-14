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
        _ cafeId: Int,
        _ questionId: Int,
        _ images: [Data?],
        _ content: String
    ) -> Observable<Result<Void,Error>>
    
    func fetchComment(_ commentId: Int) -> Observable<Result<(comment: Comment, replies: [Reply]),Error>>
}

final class DefaultCommentUseCase: CommentUseCase {
    
    private let commentRepository: CommentRepository
    
    init(commentRepository: CommentRepository) {
        self.commentRepository = commentRepository
    }
    
    func createComment(
        _ cafeId: Int,
        _ questionId: Int,
        _ images: [Data?],
        _ content: String
    ) -> Observable<Result<Void,Error>> {
        let images = images.compactMap{ $0 }
        
        return commentRepository.createComment(cafeId, questionId, images, content)
    }
    
    func fetchComment(_ commentId: Int) -> Observable<Result<(comment: Comment, replies: [Reply]), Error>> {
        commentRepository.fetchComment(commentId)
    }
}
