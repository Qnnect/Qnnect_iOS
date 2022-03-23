//
//  ReportNetworkService.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/23.
//

import Foundation
import Moya
import RxSwift

final class ReportNetworkService: BaseNetworkService<ReportAPI> {
    
    func report(request: ReportRequestDTO) -> Observable<Result<Void,Error>> {
        self.request(.report(request: request))
            .filter(statusCodes: 200 ... 300)
            .map{ _ in Result.success(())}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
    
    func releaseReport(request: ReportRequestDTO) -> Observable<Result<Void,Error>> {
        self.request(.releaseReport(request: request))
            .filter(statusCodes: 200 ... 300)
            .map{ _ in Result.success(())}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
    
    func fetchReports() -> Observable<Result<[ReportResponseDTO],Error>> {
        request(.fetchReports)
            .filter(statusCode: 200)
            .map([ReportResponseDTO].self)
            .map{ Result.success($0)}
            .catch{ .just(Result.failure($0))}
            .asObservable()
    }
        
}
