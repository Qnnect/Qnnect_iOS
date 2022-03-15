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
        let cafeId: Observable<Int>
    }
    
    struct Output {
        let dismiss: Signal<Void>
        ///Int: CafeID
        let showSelectDrinkBottomSheet: Signal<Int>
    }
    

    
    func transform(from input: Input) -> Output {
        
        let dismiss = input.didTapCancleButton
            
        
        let showSelectDrinkBottomSheet = input.didTapDrinkSelectButton
            .withLatestFrom(input.cafeId)
            
        
        return Output(
            dismiss: dismiss.asSignal(onErrorSignalWith: .empty()),
            showSelectDrinkBottomSheet: showSelectDrinkBottomSheet.asSignal(onErrorSignalWith: .empty())
        )
    }
    
}
