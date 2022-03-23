//
//  BlockedFriendListViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BlockedFriendListViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let didTapRelease: Observable<Int>
    }
    
    struct Output {
        let blockedFriends: Driver<[ReportUser]>
    }
    
    private let reportUseCase: ReportUseCase
    
    init(reportUseCase: ReportUseCase) {
        self.reportUseCase = reportUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let blockedFriends = Observable.merge(
            input.viewDidLoad,
            input.didTapRelease
                .flatMap(reportUseCase.releaseReport(_:))
                .filter {
                    guard case .success(_) = $0 else { return false}
                    return true
                }.mapToVoid()
            )
            .flatMap(reportUseCase.fetchReports)
            .debug()
            .compactMap { result -> [ReportUser]? in
                guard case let .success(users) = result else { return nil }
                return users
            }
        
       
        
        return Output(
            blockedFriends: blockedFriends.asDriver(onErrorJustReturn: [])
           
        )
    }
}
