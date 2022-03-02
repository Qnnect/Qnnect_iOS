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
    }
    
    struct Output {
        let start: Signal<Void>
        let isCompletedAgreement: Signal<Bool> //필수 항목들 체크 완료 했는 지
        let isAllAgreement: Signal<Bool> // 항목들을 전부 체크 완료 했는 지
        let isCheckedAllAgreement: Signal<Bool> // 전체 동의 버튼 체크했는 지
    }
    
    private weak var coordinator: AuthCoordinator?
    private let inputUseCase: InputUseCase
    init(
        coordinator: AuthCoordinator,
        inputUseCase: InputUseCase
    ) {
        self.coordinator = coordinator
        self.inputUseCase = inputUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let isAgreedNoti = input.checkeditem
            .map { _, _, pushNoti in
                return pushNoti
            }
        
        let start = input.didTapAgreementButton
            .withLatestFrom(Observable.combineLatest(input.token, isAgreedNoti))
            .do {
                [weak self] token, isAgreedNoti in
                self?.coordinator?.showSetProfileScene(token: token, isAgreedNoti: isAgreedNoti)
            }
            .mapToVoid()
            
            
        let isCompletedAgreement = input.checkeditem
            .map(self.inputUseCase.isEssentialItemChecked)
        
        let isAllAgreement = input.checkeditem
            .map(self.inputUseCase.isAllAgreement(_:))
            
        return Output(
            start: start.asSignal(onErrorJustReturn: ()),
            isCompletedAgreement: isCompletedAgreement.asSignal(onErrorJustReturn: false),
            isAllAgreement: isAllAgreement.asSignal(onErrorJustReturn: false),
            isCheckedAllAgreement: input.didCheckAllAgreement.asSignal(onErrorJustReturn: false)
            )
        
          
    }
}
