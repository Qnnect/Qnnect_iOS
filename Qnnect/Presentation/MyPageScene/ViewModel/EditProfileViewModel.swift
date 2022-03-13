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
        let didTapCompletionButton: Observable<Void>
        let profileImage: Observable<Data?>
        let user: Observable<User>
    }
    
    struct Output {
        let isVaildName: Signal<Bool>
        let nameLength: Driver<Int>
        let showBottomSheet: Signal<Void>
        let completion: Signal<Void>
        let pop: Signal<Void>
    }
    
    private let authUseCase: AuthUseCase
    private let userUseCase: UserUseCase
    private weak var coordinator: MyPageCoordinator?
    
    init(
        authUseCase: AuthUseCase,
        coordinator: MyPageCoordinator,
        userUseCase: UserUseCase
    ) {
        self.authUseCase = authUseCase
        self.coordinator = coordinator
        self.userUseCase = userUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let isValidName = input.inputName
            .compactMap{ $0 } // nil 제거
            .map(self.authUseCase.isVaildName(_:))
        
        let nameLength = input.inputName
            .compactMap{ $0 } // nil 제거
            .map(self.authUseCase.getNameLength(_:))
        
        let userInfo = Observable.combineLatest(
            input.profileImage,
            input.inputName,
            input.user
        ).share()
        
        
        let inputChanging = Observable.merge(
            input.inputName.skip(1)
                .withLatestFrom(input.user,resultSelector: { ($0,$1) })
                .filter { [weak self] name, originalUser in
                    return self?.userUseCase.isModifiedName(inputName: name, originalUser: originalUser) ?? false
                }.mapToVoid(),
            input.profileImage.skip(1)
                .mapToVoid()
        )
        
        let updateProfile = input.didTapCompletionButton
            .skip(until: inputChanging)
            .withLatestFrom(userInfo)
            .map{($0.0 , $0.1)}

            .flatMap(self.userUseCase.setProfile)
            .do {
                [weak self] _ in
                self?.coordinator?.pop()
            }
            .mapToVoid()
            .share()
        
        let pop = input.didTapCompletionButton
            .take(until: inputChanging)
            .do{
                [weak self] _ in
                self?.coordinator?.pop()
            }
        
        return Output(
            isVaildName: isValidName.asSignal(onErrorJustReturn: false),
            nameLength: nameLength.asDriver(onErrorDriveWith: .empty()),
            showBottomSheet: input.didTapProfileImageView.asSignal(onErrorSignalWith: .empty()),
            completion: updateProfile.asSignal(onErrorSignalWith: .empty()),
            pop: pop.asSignal(onErrorSignalWith: .empty())
        )
    }
}
