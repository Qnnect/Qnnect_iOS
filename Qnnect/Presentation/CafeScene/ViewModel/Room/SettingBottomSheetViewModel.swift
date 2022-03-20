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
        let cafeId: Observable<Int>
        let didTapLeaveAlertOkButton: Observable<Void>
    }
    
    struct Output {
        let showInvitationScene: Signal<Void>
        ///Int: CafeId
        let showCafeModifyingScene: Signal<Int>
        let showLeaveCafeAlertView: Signal<Void>
        let leaveCafe: Signal<Void>
    }
    
    private let cafeUseCase: CafeUseCase
    
    init(cafeUseCase: CafeUseCase) {
        self.cafeUseCase = cafeUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let showInvitationScene = input.didTapSettingItem
            .filter { $0 == .invite}
            .mapToVoid()
        
        let showCafeModifyingScene = input.didTapSettingItem
            .filter { $0 == .cafeInfoModify }
            .withLatestFrom(input.cafeId)
        
        let showLeaveCafeAlertView = input.didTapSettingItem
            .filter { $0 == .leaveCafe}
            .debug()
            .mapToVoid()
        
        let leaveCafe = input.didTapLeaveAlertOkButton
            .withLatestFrom(input.cafeId)
            .flatMap(self.cafeUseCase.leaveCafe(_:))
            .mapToVoid()

        return Output(
            showInvitationScene: showInvitationScene.asSignal(onErrorSignalWith: .empty()),
            showCafeModifyingScene: showCafeModifyingScene.asSignal(onErrorSignalWith: .empty()),
            showLeaveCafeAlertView: showLeaveCafeAlertView.asSignal(onErrorSignalWith: .empty()),
            leaveCafe: leaveCafe.asSignal(onErrorSignalWith: .empty())
        )
    }
}
