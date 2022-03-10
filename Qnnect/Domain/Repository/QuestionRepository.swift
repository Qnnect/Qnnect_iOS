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
}
