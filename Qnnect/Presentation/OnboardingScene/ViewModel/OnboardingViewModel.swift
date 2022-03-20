//
//  OnboardingViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/23.
//

import Foundation
import RxSwift
import RxCocoa


final class OnboardingViewModel: ViewModelType {
    
    struct Input {
        let didTapStartButton: Observable<Void>
        let inviteCode: Observable<String>
    }
    
    struct Output {
        let showLoingScene: Signal<Void>
        let inviteFlowLoginScene: Signal<String>
    }
    
    
    init() {
        
    }
    
    func transform(from input: Input) -> Output {
        
        let showLoingScene = input.didTapStartButton
            .take(until: input.inviteCode)
        
        let inviteFlowLoginScene = input.didTapStartButton
            .withLatestFrom(input.inviteCode)
            
        return Output(
            showLoingScene: showLoingScene.asSignal(onErrorSignalWith: .empty()),
            inviteFlowLoginScene: inviteFlowLoginScene.asSignal(onErrorSignalWith: .empty())
        )
    }
}


