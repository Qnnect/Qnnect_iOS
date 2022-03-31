//
//  JoinCafeBottomSheetViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/21.
//

import Foundation
import RxCocoa
import RxSwift

final class JoinCafeBottomSheetViewModel: ViewModelType {
    
    struct Input {
        let cafeCode: Observable<String>
        let didTapCompletionButton: Observable<Void>
    }
    
    struct Output {
        ///Int: CafeId
        let showCafeRoomScene: Signal<Int>
        let showCafeJoinErrorAlertView: Signal<String>
    }
    
    private let cafeUseCase: CafeUseCase
    
    init(cafeUseCase: CafeUseCase) {
        self.cafeUseCase = cafeUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let joinCafe = input.didTapCompletionButton
            .withLatestFrom(input.cafeCode)
            .flatMap(cafeUseCase.joinCafe(_:))
            .share()
        
        let joinedCafeId = joinCafe.compactMap{
            result -> Int? in
            guard case let .success(cafeId) = result else { return nil }
            return cafeId
        }
        
        let showCafeJoinErrorAlertView = joinCafe
            .compactMap { result -> JoinCafeError? in
                guard case let .failure(error) = result else { return nil }
                if error == .alreadyIn {
                    return nil
                } else {
                    return error
                }
            }.map { $0.meessage }
        
        
        return Output(
            showCafeRoomScene: joinedCafeId.asSignal(onErrorSignalWith: .empty()),
            showCafeJoinErrorAlertView: showCafeJoinErrorAlertView.asSignal(onErrorSignalWith: .empty())
        )
    }
}
