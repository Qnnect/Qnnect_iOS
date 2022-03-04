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
        let didTapProfileImageView: Observable<Void>
    }
    
    struct Output {
        let isVaildName: Signal<Bool>
        let nameLength: Driver<Int>
        let showBottomSheet: Signal<Void>
    }
    private let authUseCase: AuthUseCase
    private weak var coordinator: MyPageCoordinator?
    
    init(authUseCase: AuthUseCase, coordinator: MyPageCoordinator) {
        self.authUseCase = authUseCase
        self.coordinator = coordinator
    }
    
    func transform(from input: Input) -> Output {
        let isValidName = input.inputName
            .compactMap{ $0 } // nil 제거
            .map(self.authUseCase.isVaildName(_:))
        
        let nameLength = input.inputName
            .compactMap{ $0 } // nil 제거
            .map(self.authUseCase.getNameLength(_:))
        
        return Output(
            isVaildName: isValidName.asSignal(onErrorJustReturn: false),
            nameLength: nameLength.asDriver(onErrorDriveWith: .empty()),
            showBottomSheet: input.didTapProfileImageView.asSignal(onErrorSignalWith: .empty())
        )
    }
}
