//
//  SettingBottomSheetViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/07.
//

import Foundation
import RxSwift
import RxCocoa

final class SettingBottomSheetViewModel: ViewModelType {
    
    struct Input {
        let didTapSettingItem: Observable<SettingItemType>
        let cafe: Observable<Cafe>
        let didTapLeaveAlertOkButton: Observable<Void>
    }
    
    struct Output {
        let showInvitationScene: Signal<Cafe>
        ///Int: CafeId
        let showCafeModifyingScene: Signal<Int>
        let showLeaveCafeAlertView: Signal<Void>
        ///Int: CafeId
        let showSelectDrinkScene: Signal<Int>
        let showNotModifyDrinkAlertView: Signal<Void>
        let leaveCafe: Signal<Void>
    }
    
    private let cafeUseCase: CafeUseCase
    
    init(cafeUseCase: CafeUseCase) {
        self.cafeUseCase = cafeUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let cafeId = input.cafe.map { $0.cafeId }
        
        let isDrinkEmpty = input.cafe.map{ $0.currentUser.filledIngredients.isEmpty }
    
        let showInvitationScene = input.didTapSettingItem
            .filter { $0 == .invite}
            .withLatestFrom(input.cafe)
        
        let showCafeModifyingScene = input.didTapSettingItem
            .filter { $0 == .cafeInfoModify }
            .withLatestFrom(cafeId)
        
        let showLeaveCafeAlertView = input.didTapSettingItem
            .filter { $0 == .leaveCafe}
            .debug()
            .mapToVoid()
        
        let leaveCafe = input.didTapLeaveAlertOkButton
            .withLatestFrom(cafeId)
            .flatMap(self.cafeUseCase.leaveCafe(_:))
            .mapToVoid()
        
        let showSelectDrinkScene = input.didTapSettingItem
            .filter{ $0 == .drinkModify }
            .withLatestFrom(isDrinkEmpty)
            .filter{ $0 }
            .withLatestFrom(cafeId)
        
        let showNotModifyDrinkAlertView = input.didTapSettingItem
            .filter{ $0 == .drinkModify }
            .withLatestFrom(isDrinkEmpty)
            .filter{ !$0 }
            .mapToVoid()
        
        return Output(
            showInvitationScene: showInvitationScene.asSignal(onErrorSignalWith: .empty()),
            showCafeModifyingScene: showCafeModifyingScene.asSignal(onErrorSignalWith: .empty()),
            showLeaveCafeAlertView: showLeaveCafeAlertView.asSignal(onErrorSignalWith: .empty()),
            showSelectDrinkScene: showSelectDrinkScene.asSignal(onErrorSignalWith: .empty()),
            showNotModifyDrinkAlertView: showNotModifyDrinkAlertView.asSignal(onErrorSignalWith: .empty()),
            leaveCafe: leaveCafe.asSignal(onErrorSignalWith: .empty())
        )
    }
}
