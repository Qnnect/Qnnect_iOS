//
//  CommentRepository.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/14.
//

import Foundation
import RxSwift

protocol CommentRepository: AnyObject {
    func createComment(
        _ questionId: Int,
        _ images: [Data],
        _ content: String
    ) -> Observable<Result<Void,CommentCreateError>>
    
    func fetchComment(_ commentId: Int) -> Observable<
        Result<(comment: Comment, replies: [Reply], cafeQuestionId: Int),Error>
    >
    func deleteComment(_ commentId: Int) -> Observable<Result<Void,Error>>
    func modifyComment(_ commentId: Int, _ images: [Data], _ content: String) -> Observable<Result<Void,Error>>
    
    func createReply(_ commentId: Int, _ content: String) -> Observable<Result<Void,Error>>
    func deleteReply(_ commentId: Int, _ replyId: Int) -> Observable<Result<Void,Error>>
    func modifyReply(_ commentId: Int, _ replyId: Int, _ content: String) -> Observable<Result<Void,Error>>
    
    func fetchQuestionSimpleInfo(_ cafeQuestionId: Int) -> Observable<Result<Question, Error>>
}
