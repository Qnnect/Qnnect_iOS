//
//  TermsViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/14.
//

import Foundation
import RxSwift
import RxCocoa

final class TermsViewModel: ViewModelType {
    
    struct Input {
        let didTapAgreementButton: Observable<Void>
        let didCheckAllAgreement: Observable<Bool>
        let checkeditem: Observable<(personal: Bool, service: Bool, pushNoti: Bool)>
        let token: Observable<Token>
        let loginType: Observable<LoginType>
        let inviteCode: Observable<String>
    }
    
    struct Output {
        let start: Signal<(token: Token, isAgreedNoti: Bool, loginType: LoginType)>
        let isCompletedAgreement: Signal<Bool> //필수 항목들 체크 완료 했는 지
        let isAllAgreement: Signal<Bool> // 항목들을 전부 체크 완료 했는 지
        let isCheckedAllAgreement: Signal<Bool> // 전체 동의 버튼 체크했는 지
        let inviteFlowNextScene: Signal<(Token, Bool, LoginType, String)>
    }
    
    private weak var coordinator: AuthCoordinator?
    private let authUseCase: AuthUseCase
    
    init(authUseCase: AuthUseCase) {
        self.authUseCase = authUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let isAgreedNoti = input.checkeditem
            .map { _, _, pushNoti in
                return pushNoti
            }
        
        let start = input.didTapAgreementButton
            .take(until: input.inviteCode)
            .withLatestFrom(Observable.combineLatest(input.token, isAgreedNoti, input.loginType))
            .map { (token: $0, isAgreedNoti: $1, loginType: $2) }
            
        let isCompletedAgreement = input.checkeditem
            .map(self.authUseCase.isEssentialItemChecked)
        
        let isAllAgreement = input.checkeditem
            .map(self.authUseCase.isAllAgreement(_:))
            
        let inviteFlowNextscene = input.didTapAgreementButton
            .take(until: input.inviteCode)
            .withLatestFrom(Observable.combineLatest(input.token, isAgreedNoti, input.loginType,input.inviteCode))
            .map { ($0, $1, $2, $3) }
        
        return Output(
            start: start.asSignal(onErrorSignalWith: .empty()),
            isCompletedAgreement: isCompletedAgreement.asSignal(onErrorJustReturn: false),
            isAllAgreement: isAllAgreement.asSignal(onErrorJustReturn: false),
            isCheckedAllAgreement: input.didCheckAllAgreement.asSignal(onErrorJustReturn: false),
            inviteFlowNextScene: inviteFlowNextscene.asSignal(onErrorSignalWith: .empty())
            )
        
          
    }
}
