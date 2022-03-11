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
    }
    
    struct Output {
        let showInvitationScene: Signal<Void>
        let showCafeModifyingScene: Signal<Void>
        let leaveCafe: Signal<Void>
    }
    
    private weak var coordinator: CafeCoordinator?
    private let cafeUseCase: CafeUseCase
    
    init(
        coordinator: CafeCoordinator,
        cafeUseCase: CafeUseCase
    ) {
        self.coordinator = coordinator
        self.cafeUseCase = cafeUseCase
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
            .withLatestFrom(input.cafeId)
            .do {
                [weak self] cafeId in
                self?.coordinator?.showCafeModifyingScene(cafeId)
            }
            .mapToVoid()
        
        let leaveCafe = input.didTapSettingItem
            .filter { $0 == .leaveCafe}
            .withLatestFrom(input.cafeId)
            .flatMap(self.cafeUseCase.leaveCafe(_:))
            .do {
                [weak self] cafeId in
                self?.coordinator?.leaveCafe()
            }
            .mapToVoid()
        
        return Output(
            showInvitationScene: showInvitationScene.asSignal(onErrorSignalWith: .empty()),
            showCafeModifyingScene: showCafeModifyingScene.asSignal(onErrorSignalWith: .empty()),
            leaveCafe: leaveCafe.asSignal(onErrorSignalWith: .empty())
        )
    }
}
