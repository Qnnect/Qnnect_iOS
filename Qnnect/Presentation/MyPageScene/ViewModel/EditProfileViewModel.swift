//
//  EditProfileViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/21.
//

import Foundation
import RxSwift
import RxCocoa

final class EditProfileViewModel: ViewModelType {
    
    struct Input {
        let inputName: Observable<String>
    }
    
    struct Output {
        let isVaildName: Signal<Bool>
        let nameLength: Driver<Int>
    }
    private let inputUseCase: InputUseCase
    private weak var coordinator: MyPageCoordinator?
    
    init(inputUseCase: InputUseCase, coordinator: MyPageCoordinator) {
        self.inputUseCase = inputUseCase
        self.coordinator = coordinator
    }
    
    func transform(from input: Input) -> Output {
        let isValidName = input.inputName
            .compactMap{ $0 } // nil 제거
            .map(self.inputUseCase.isVaildName(_:))
        
        let nameLength = input.inputName
            .compactMap{ $0 } // nil 제거
            .map(self.inputUseCase.getNameLength(_:))
        
        return Output(
            isVaildName: isValidName.asSignal(onErrorJustReturn: false),
            nameLength: nameLength.asDriver(onErrorDriveWith: .empty())
        )
    }
}
