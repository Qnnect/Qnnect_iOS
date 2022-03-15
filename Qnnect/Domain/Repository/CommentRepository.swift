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
    ) -> Observable<Result<Void,Error>>
    
    func fetchComment(_ commentId: Int) -> Observable<
        Result<(comment: Comment, replies: [Reply], isWriter: Bool),Error>
    >
    func createReply(_ commentId: Int, _ content: String) -> Observable<Result<Void,Error>>
    func deleteComment(_ commentId: Int) -> Observable<Result<Void,Error>>
}
