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
    }
    
    struct Output {
        let report: Signal<Void>
    }
    
    
    
    func transform(from input: Input) -> Output {
        return Output(
            report: input.didTapReportButton.asSignal(onErrorSignalWith: .empty())
        )
    }
}
