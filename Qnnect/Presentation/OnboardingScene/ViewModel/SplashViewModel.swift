//
//  SplashViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/23.
//

import Foundation
import RxSwift
import RxCocoa

final class SplashViewModel: ViewModelType {
    
    struct Input {
        let didEndSplash: Observable<Void>
        let inviteCode: Observable<String>
    }
    
    struct Output {
        let showOnboarding: Signal<Void>
        let showLogin: Signal<Void>
        let showMain: Signal<Void>
        let inviteFloswOnboarding: Signal<String>
        let inviteFlowShowLogin: Signal<String>
        let inviteFlowAutoLogin: Signal<String>
    }
    
    private let authUseCase: AuthUseCase
    
    init(
        authUseCase: AuthUseCase
    ) {
        self.authUseCase = authUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let isFirstAccess = input.didEndSplash
            .map(self.authUseCase.fetchIsFirstAccess)
            .share()
        
        let firstAccess = isFirstAccess
            .take(until: input.inviteCode)
            .filter{ $0 }
            .mapToVoid()

        
        
        let inviteFlowFirstAccess = isFirstAccess
            .filter { $0 }
            .mapToVoid()
            .withLatestFrom(input.inviteCode)

    
        
        let reissueToken = input.didEndSplash
            .map(self.authUseCase.fetchToken)
            .compactMap{ $0 } // nil 삭제
            .flatMap(self.authUseCase.reissueToken(token:))
            .share()
        
        let autoLogin = reissueToken
            .take(until: input.inviteCode)
            .filter {
                guard case .success(_) = $0 else { return false }
                return true
            }
            .mapToVoid()
        
        let inviteFlowAutoLogin = reissueToken
            .filter {
                guard case .success(_) = $0 else { return false }
                return true
            }.withLatestFrom(input.inviteCode)
        
        
        let tokenNil = input.didEndSplash
            .map(self.authUseCase.fetchToken)
            .filter { $0 == nil }
            .mapToVoid()
        
        let needToLogin = reissueToken
            .filter {
                guard case .failure(_) = $0 else { return false }
                return true
            }//TODO: 500에러로 변경
            .mapToVoid()
        
        let showLogin = isFirstAccess
            .take(until: input.inviteCode)
            .filter{ !$0 }
            .withLatestFrom(Observable.merge(tokenNil,needToLogin))
            .mapToVoid()
        
        let inviteFlowShowLogin = isFirstAccess
            .filter{ !$0 }
            .withLatestFrom(Observable.merge(tokenNil,needToLogin))
            .withLatestFrom(input.inviteCode)
        
        return Output(
            showOnboarding: firstAccess.asSignal(onErrorSignalWith: .empty()),
            showLogin: showLogin.asSignal(onErrorSignalWith: .empty()),
            showMain: autoLogin.asSignal(onErrorSignalWith: .empty()),
            inviteFloswOnboarding: inviteFlowFirstAccess.asSignal(onErrorSignalWith: .empty()),
            inviteFlowShowLogin: inviteFlowShowLogin.asSignal(onErrorSignalWith: .empty()),
            inviteFlowAutoLogin: inviteFlowAutoLogin.asSignal(onErrorSignalWith: .empty())
        )
    }
    
}


private extension SplashViewModel {
    
    func isExistedUser(_ userLoginInfo: UserLoginInfo) -> Bool {
        return (!userLoginInfo.isNewMember && userLoginInfo.userSettingDone)
    }
    
    func convertToUserLoginInfo(_ result: Result<UserLoginInfo, LoginError>) -> UserLoginInfo? {
        guard case let .success(userLoginInfo) = result  else { return nil }
        return userLoginInfo
    }
    
    func isAccessTokenExpiration(result: Result<UserLoginInfo,LoginError>) -> Bool {
        if case let .failure(loginError) = result {
            if loginError == .accessTokenExpiration {
                return true
            }
        }
        return false
    }
}
