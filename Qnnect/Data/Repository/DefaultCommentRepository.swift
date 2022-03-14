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
    
    init(commentNetworkService: CommentNetworkService) {
        self.commentNetworkService = commentNetworkService
    }
    
    func createComment(
        _ cafeId: Int,
        _ questionId: Int,
        _ images: [Data],
        _ content: String
    ) -> Observable<Result<Void,Error>> {
        commentNetworkService.createComment(cafeId, questionId, images, content)
    }
    
    func fetchComment(_ commentId: Int) -> Observable<Result<(comment: Comment, replies: [Reply]), Error>> {
        commentNetworkService.fetchComment(commentId)
            .map {
                result -> Result<(comment: Comment, replies: [Reply]),Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.toDomain())
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
}
