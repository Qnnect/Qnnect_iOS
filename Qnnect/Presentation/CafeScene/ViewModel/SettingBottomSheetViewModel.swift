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
    }
    
    struct Output {
        let showInvitationScene: Signal<Void>
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
        
        return Output(
            showInvitationScene: showInvitationScene.asSignal(onErrorSignalWith: .empty())
        )
    }
}
