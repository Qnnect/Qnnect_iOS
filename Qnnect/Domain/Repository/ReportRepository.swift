//
//  ReportRepository.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/23.
//

import Foundation
import RxSwift

protocol ReportRepository: AnyObject {
    func report(_ reportId: Int) -> Observable<Result<Void,Error>>
    func releaseReport(_ reportId: Int) -> Observable<Result<Void,Error>>
    func fetchReports() -> Observable<Result<[ReportUser],Error>>
}
