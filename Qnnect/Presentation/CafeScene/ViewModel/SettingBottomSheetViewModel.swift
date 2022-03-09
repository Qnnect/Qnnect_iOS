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
        let roomInfo: Observable<Cafe>
    }
    
    struct Output {
        let showInvitationScene: Signal<Void>
        let showCafeModifyingScene: Signal<Void>
    }
    
    private weak var coordinator: CafeCoordinator?
    
    init(coordinator: CafeCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(from input: Input) -> Output {
        
        let showInvitationScene = input.didTapSettingItem
            .do {
                [weak self] type in
                if type == .invite {
                    self?.coordinator?.showInvitationScene()
                }
            }
            .mapToVoid()
        
        let showCafeModifyingScene = input.didTapSettingItem
            .filter { $0 == .cafeInfoModify }
            .withLatestFrom(input.roomInfo)
            .do {
                [weak self] cafe in
                self?.coordinator?.showCafeModifyingScene(cafe)
            }
            .mapToVoid()
        
        return Output(
            showInvitationScene: showInvitationScene.asSignal(onErrorSignalWith: .empty()),
            showCafeModifyingScene: showCafeModifyingScene.asSignal(onErrorSignalWith: .empty())
        )
    }
}
