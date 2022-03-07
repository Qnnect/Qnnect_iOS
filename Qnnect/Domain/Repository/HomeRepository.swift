//
//  HomeRepository.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/07.
//

import Foundation
import RxSwift

protocol HomeRepository: AnyObject {
    func fetchHomeInfo() -> Observable<Result<HomeInfo,Error>>
}
