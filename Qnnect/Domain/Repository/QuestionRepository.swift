//
//  QuestionRepository.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/10.
//

import Foundation
import RxSwift

protocol QuestionRepository: AnyObject {
    func scrap(_ questionId: Int) -> Observable<Result<Void,Error>>
    func cancleScrap(_ questionId: Int) -> Observable<Result<Void,Error>>
    func fetchAllScrap(_ page: Int, _ size: Int) -> Observable<Result<[ScrapedQuestion],Error>>
    func fetchScrap(_ cafeId: Int, _ page: Int, _ size: Int) -> Observable<Result<[ScrapedQuestion],Error>>
    func fetchCafes() -> Observable<Result<[CafeTag],Error>>
    func fetchQuestion(_ questionId: Int) -> Observable<Result<(
        comments: [Comment],
        question: Question,
        liked: Bool,
        scraped: Bool),Error>>
}
