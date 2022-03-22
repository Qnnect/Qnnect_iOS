//
//  MyPageAlertViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/23.
//

import Foundation
import RxSwift
import RxCocoa

final class MyPageAlertViewModel: ViewModelType {
    
    struct Input {
        let myPageItem: Observable<MyPageItem>
        let didTapOkButton: Observable<Void>
        
    }
    
    struct Output {
        let logout: Signal<Void>
        let withdrawl: Signal<Void>
    }
    
    private let authUseCase: AuthUseCase
    
    init(authUseCase: AuthUseCase) {
        self.authUseCase = authUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let trigger = input.didTapOkButton
            .withLatestFrom(input.myPageItem)
            
        let logout = trigger.filter { $0 == .logout }
            .mapToVoid()
            .flatMap(authUseCase.logout)
            .filter {
                result -> Bool in
                guard case .success(_) = result else { return false}
                return true
            }
            .do {
                 _ in
                KeyChain.delete(key: Constants.accessTokenKey)
                KeyChain.delete(key: Constants.refreshTokenKey)
            }
            .mapToVoid()
        
        let withdrawl = trigger.filter{ $0 == .withdrawal}
            .mapToVoid()
            .flatMap(authUseCase.withdraw)
            .filter {
                result -> Bool in
                guard case .success(_) = result else { return false}
                return true
            }
            .do {
                 _ in
                KeyChain.delete(key: Constants.accessTokenKey)
                KeyChain.delete(key: Constants.refreshTokenKey)
            }
            .mapToVoid()
        
        return Output(
            logout: logout.asSignal(onErrorSignalWith: .empty()),
            withdrawl: withdrawl.asSignal(onErrorSignalWith: .empty())
        )
    }
}
