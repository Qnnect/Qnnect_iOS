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
        let curQuestionPage: Observable<Int>
        let viewWillAppear: Observable<Void>
        let didTapMyCafe: Observable<Void>
    }
    
    struct Output {
        let showAddGroupBottomSheet: Signal<Void>
        let curQuestionPage: Driver<Int>
        let showCafeRoom: Signal<Void>
    }
    
    private weak var coordinator: HomeCoordinator?
    
    init(coordinator:HomeCoordinator) {
        self.coordinator = coordinator
    }
    func transform(from input: Input) -> Output {
        
        let showAddGroupBottomSheet = input.didTapAddGroupButton
            .do{ [weak self] _ in
                self?.coordinator?.showAddGroupBottomSheet()
            }
        
        let showCafeRoom = input.didTapMyCafe
            .do {
                [weak self] _ in
                self?.coordinator?.showGroupScene(with: 12)
            }
        
        return Output(
            showAddGroupBottomSheet: showAddGroupBottomSheet.asSignal(onErrorSignalWith: .empty()),
            curQuestionPage: input.curQuestionPage.asDriver(onErrorJustReturn: 0),
            showCafeRoom: showCafeRoom.asSignal(onErrorSignalWith: .empty())
        )
    }
}
