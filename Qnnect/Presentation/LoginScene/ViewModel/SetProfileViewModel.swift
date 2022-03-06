//
//  InputNameViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/14.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftUI

final class SetProfileViewModel: ViewModelType {
    
    struct Input {
        let inputName: Observable<String?>
        let didTapCompletionButton: Observable<String>
        let viewDidLoad: Observable<Void>
        let token: Observable<Token>
        let isAgreedNoti: Observable<Bool>
        let profileImageData: Observable<Data>
        let loginType: Observable<LoginType>
    }
    
    struct Output {
        let nameLength: Driver<Int>
        let isValidName: Driver<Bool>
        let completion: Signal<Void>
        let kakaoProfileImageURL: Driver<URL?>
    }
    
    private weak var coordinator: AuthCoordinator?
    private let authUseCase: AuthUseCase
    private let userUseCase: UserUseCase
    var authManager: SocialLoginManager!
    
    init(
        coordinator: AuthCoordinator,
        authUseCase: AuthUseCase,
        userUseCase: UserUseCase
    ) {
        self.coordinator = coordinator
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
        
        let userInfo = Observable.combineLatest(input.token, input.isAgreedNoti, input.profileImageData, input.inputName.compactMap{$0})
        
        let setting = input.didTapCompletionButton
            .withLatestFrom(userInfo)
            .do{
                [weak self] token, _ , _ , _ in
                self?.authUseCase.saveToken(access: token.access, refresh: token.refresh)
            }
            .share()
        
        let settingEnableNotification = setting
            .map{ ($0.1) }
            .flatMap(self.userUseCase.setEnableNotification)
            
        let settingProfile = setting
            .map{ ($0.2, $0.3) }
            .flatMap(self.userUseCase.setProfile)
            .compactMap{
                result -> User? in
                guard case let .success(user) = result else { return nil }
                return user
            }
        
        let completion = Observable.zip(settingEnableNotification, settingProfile)
            .withLatestFrom(input.loginType)
            .do {
                [weak self] loginType in
                self?.authUseCase.saveLoginType(loginType)
            }
            .mapToVoid()
            .do {
                [weak self] _ in
                self?.coordinator?.showMain()
            }
        
        let kakaoProfileImageURL = input.viewDidLoad
                .flatMap(self.authManager.getUserProfileImageInKakao)
                
        return Output(
            nameLength: nameLength.asDriver(onErrorJustReturn: 0),
            isValidName: isValidName.asDriver(onErrorJustReturn: false),
            completion: completion.asSignal(onErrorJustReturn: ()),
            kakaoProfileImageURL: kakaoProfileImageURL.asDriver(onErrorJustReturn: nil)
        )
    }
}

