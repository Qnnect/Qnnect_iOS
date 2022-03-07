//
//  DrinkSelectGuideAlertViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/07.
//

import Foundation
import RxSwift
import RxCocoa

final class DrinkSelectGuideAlertViewModel: ViewModelType {
    
    struct Input {
        let didTapCancleButton: Observable<Void>
        let didTapDrinkSelectButton: Observable<Void>
    }
    
    struct Output {
        let dismiss: Signal<Void>
        let showSelectDrinkBottomSheet: Signal<Void>
    }
    
    private weak var coordinator: CafeCoordinator?
    
    init(coordinator: CafeCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(from input: Input) -> Output {
        
        let dismiss = input.didTapCancleButton
            .do {
                [weak self] _ in
                self?.coordinator?.dismissAlert()
            }
        
        let showSelectDrinkBottomSheet = input.didTapDrinkSelectButton
            .do {
                [weak self] _ in
                self?.coordinator?.showSelectDrinkBottomSheet()
            }
        
        return Output(
            dismiss: dismiss.asSignal(onErrorSignalWith: .empty()),
            showSelectDrinkBottomSheet: showSelectDrinkBottomSheet.asSignal(onErrorSignalWith: .empty())
        )
    }
    
}
