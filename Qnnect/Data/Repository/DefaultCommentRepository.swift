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
}
