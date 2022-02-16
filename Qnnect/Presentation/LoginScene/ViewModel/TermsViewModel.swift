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
    }
    
    struct Output {
        let start: Signal<Void>
        let isCompletedAgreement: Signal<Bool> //필수 항목들 체크 완료 했는 지
        let isAllAgreement: Signal<Bool> // 항목들을 전부 체크 완료 했는 지
        let isCheckedAllAgreement: Signal<Bool> // 전체 동의 버튼 체크했는 지
    }
    
    private weak var coordinator: AuthCoordinator?
    private let signUpUseCase: SignUpUseCase
    init(
        coordinator: AuthCoordinator,
        signUpUseCase: SignUpUseCase
    ) {
        self.coordinator = coordinator
        self.signUpUseCase = signUpUseCase
    }
    
    func transform(from input: Input) -> Output {
        let start = input.didTapAgreementButton
            .do {
                [weak self] _ in
                self?.coordinator?.showInputNameVC()
            }
        
        let isCompletedAgreement = input.checkeditem
            .map(self.signUpUseCase.isEssentialItemChecked)
        
        let isAllAgreement = input.checkeditem
            .map(self.signUpUseCase.isAllAgreement(_:))
            
        return Output(
            start: start.asSignal(onErrorJustReturn: ()),
            isCompletedAgreement: isCompletedAgreement.asSignal(onErrorJustReturn: false),
            isAllAgreement: isAllAgreement.asSignal(onErrorJustReturn: false),
            isCheckedAllAgreement: input.didCheckAllAgreement.asSignal(onErrorJustReturn: false)
            )
        
          
    }
}
