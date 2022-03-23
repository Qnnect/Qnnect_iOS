//
//  ReportUseCase.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/24.
//

import Foundation
import RxSwift

protocol ReportUseCase: AnyObject {
    func report(_ reportId: Int) -> Observable<Result<Void,Error>>
    func releaseReport(_ reportId: Int) -> Observable<Result<Void,Error>>
    func fetchReports() -> Observable<Result<[ReportUser],Error>>
}

final class DefaultReportUseCase: ReportUseCase {
    
    private let reportRepository: ReportRepository
    
    init(reportRepository: ReportRepository) {
        self.reportRepository = reportRepository
    }
    
    func report(_ reportId: Int) -> Observable<Result<Void, Error>> {
        reportRepository.report(reportId)
    }
    
    func releaseReport(_ reportId: Int) -> Observable<Result<Void, Error>> {
        reportRepository.releaseReport(reportId)
    }
    
    func fetchReports() -> Observable<Result<[ReportUser], Error>> {
        reportRepository.fetchReports()
    }
}
