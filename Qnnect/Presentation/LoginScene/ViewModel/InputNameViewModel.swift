//
//  InputNameViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/14.
//

import Foundation
import RxSwift
import RxCocoa


final class InputNameViewModel: ViewModelType {
    
    struct Input {
        let inputName: Observable<String?>
        let didTapCompletionButton: Observable<String>
    }
    
    struct Output {
        let nameLength: Driver<Int>
        let isValidName: Driver<Bool>
        let completion: Signal<Void>
    }
    
    private let coordinator: LoginCoordinator
    private let inputUseCase: InputUseCase
    
    init(coordinator: LoginCoordinator, inputUseCase: InputUseCase) {
        self.coordinator = coordinator
        self.inputUseCase = inputUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let isValidName = input.inputName
            .compactMap{ $0 } // nil 제거
            .map(self.inputUseCase.isVaildName(_:))
        
        let nameLength = input.inputName
            .compactMap{ $0 } // nil 제거
            .map(self.inputUseCase.getNameLength(_:))
        
        //TODO: 완료버튼 클릭 시 같이 전달되는 닉네임을 서버로 전송
        let completion = input.didTapCompletionButton
            .mapToVoid()
            .do(onNext: {
                [weak self] _ in
                self?.coordinator.showTermsVC()
            })
        return Output(
            nameLength: nameLength.asDriver(onErrorJustReturn: 0),
            isValidName: isValidName.asDriver(onErrorJustReturn: false),
            completion: completion.asSignal(onErrorJustReturn: ())
        )
    }
}
