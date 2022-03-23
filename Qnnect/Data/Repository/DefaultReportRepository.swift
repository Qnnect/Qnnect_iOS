//
//  DefaultReportRepository.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/23.
//

import Foundation
import RxSwift

final class DefaultReportRepository: ReportRepository {
    
    private let reportNetworkService: ReportNetworkService
    
    init(reportNetworkService: ReportNetworkService) {
        self.reportNetworkService = reportNetworkService
    }
    
    func report(_ reportId: Int) -> Observable<Result<Void,Error>> {
        let request = ReportRequestDTO(reportId: reportId)
        return reportNetworkService.report(request: request)
    }
    func releaseReport(_ reportId: Int) -> Observable<Result<Void,Error>> {
        let request = ReportRequestDTO(reportId: reportId)
        return reportNetworkService.releaseReport(request: request)
    }
    
    func fetchReports() -> Observable<Result<[ReportUser],Error>> {
        reportNetworkService.fetchReports()
            .map {
                result -> Result<[ReportUser],Error> in
                switch result {
                case .success(let responseDTO):
                    return .success(responseDTO.map{$0.toDomain()})
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
}
