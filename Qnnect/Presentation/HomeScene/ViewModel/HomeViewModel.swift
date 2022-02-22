//
//  HomeViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/14.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelType {
    
    struct Input {
        let didTapAddGroupButton: Observable<Void>
    }
    
    struct Output {
        let showAddGroupBottomSheet: Signal<Void>
    }
    
    private weak var coordinator: HomeCoordinator?
    
    init(coordinator:HomeCoordinator) {
        self.coordinator = coordinator
    }
    func transform(from input: Input) -> Output {
        
        let showAddGroupBottomSheet = input.didTapAddGroupButton
            .do(onNext: { [weak self] _ in
                self?.coordinator?.showAddGroupBottomSheet()
            })
        return Output(
            showAddGroupBottomSheet: showAddGroupBottomSheet.asSignal(onErrorSignalWith: .empty())
        )
    }
}
