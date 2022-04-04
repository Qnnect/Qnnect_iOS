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
        let pop: Signal<Void>
        let setDefaultImage: Signal<Void>
        let updateError: Signal<Void>
    }
    
    private let authUseCase: AuthUseCase
    private let userUseCase: UserUseCase
    
    init(
        authUseCase: AuthUseCase,
        userUseCase: UserUseCase
    ) {
        self.authUseCase = authUseCase
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
        
        let updateInfo = input.didTapCompletionButton
            .skip(until: inputChanging)
            .withLatestFrom(userInfo)
            .map{($0.0 , $0.1)}
        
        let setDefaultImage = updateInfo.filter { $0.0 == nil}
            .mapToVoid()
            .flatMap(userUseCase.setDefaultImage)
            .mapToVoid()
        
        let updateProfile = updateInfo
            .flatMap {
                [weak self] imageData, name -> Observable<Result<Void,Error>> in
                guard let self = self else { return .just(.success(Void())) }
                if imageData == nil {
                    return self.userUseCase.setDefaultImage()
                } else {
                    return .just(.success(Void()))
                }
            }
            .withLatestFrom(updateInfo)
            .flatMap(self.userUseCase.setProfile)
            .share()
        
        let updateSuccess = updateProfile.filter({ result in
            guard case .success(_) = result else { return false}
            return true
        }).mapToVoid()
        
        let updateError = updateProfile.filter({ result in
            guard case .failure(_) = result else { return false}
            return true
        }).mapToVoid()
        
        let pop = Observable.merge(input.didTapCompletionButton
            .take(until: inputChanging),updateSuccess)
            
        
        return Output(
            isVaildName: isValidName.asSignal(onErrorJustReturn: false),
            nameLength: nameLength.asDriver(onErrorDriveWith: .empty()),
            showBottomSheet: input.didTapProfileImageView.asSignal(onErrorSignalWith: .empty()),
            pop: pop.asSignal(onErrorSignalWith: .empty()),
            setDefaultImage: setDefaultImage.asSignal(onErrorSignalWith: .empty()),
            updateError: updateError.asSignal(onErrorSignalWith: .empty())
        )
    }
}
