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
        _ cafeId: Int,
        _ questionId: Int,
        _ images: [Data],
        _ content: String
    ) -> Observable<Result<Void,Error>>
}
