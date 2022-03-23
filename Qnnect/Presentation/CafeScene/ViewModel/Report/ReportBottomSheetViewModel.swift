//
//  ReportBottomSheetViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/23.
//

import Foundation
import RxSwift
import RxCocoa

final class ReportBottomSheetViewModel: ViewModelType {
    
    struct Input {
        let didTapReportButton: Observable<Void>
        let didTapblockButton: Observable<Void>
        let reportUser: Observable<User>
    }
    
    struct Output {
        let report: Signal<User>
        let block: Signal<Void>
    }
    
    private let reportUseCase: ReportUseCase
    
    init(reportUseCase: ReportUseCase) {
        self.reportUseCase = reportUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let report = input.didTapReportButton
            .withLatestFrom(input.reportUser)
            .map { $0.reportId }
            .flatMap(reportUseCase.report(_:))
            .withLatestFrom(input.reportUser)
        
        let block = input.didTapblockButton
            .withLatestFrom(input.reportUser)
            .map { $0.reportId }
            .flatMap(reportUseCase.report(_:))
            .mapToVoid()
        
        return Output(
            report: report.asSignal(onErrorSignalWith: .empty()),
            block: block.asSignal(onErrorSignalWith: .empty())
        )
    }
}
