//
//  MyPageViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/16.
//

import Foundation
import RxSwift
import RxCocoa


final class MyPageViewModel: ViewModelType {
    
    struct Input {
        //TODO: 나중에 프로필이랑 이미지 사진 전송해야함 Void -> User
        let didTapProfileCell: Observable<Void>
        let viewWillAppear: Observable<Void>
        let viewDidLoad: Observable<Void>
        let didTapMyDrinkStampButton: Observable<Void>
        let didTapSendedQuestionButton: Observable<Void>
        let didTapMyPagaItem: Observable<MyPageItem>
    }
    
    struct Output {
        let showEditProfileScene: Signal<User>
        let user: Driver<User>
        let loginType: Driver<LoginType>
        let showMyDrinkStampButton: Signal<User>
        let showMyPageAlertView: Signal<MyPageItem>
        let showPersonalPolicy: Signal<Void>
        let showTermsOfService: Signal<Void>
        let showQnnectInstagram: Signal<Void>
        let showSendedQuestionListScene: Signal<Void>
    }
    
    private let userUseCase: UserUseCase
    
    init(userUseCase: UserUseCase) {
        self.userUseCase = userUseCase
    }
    
    func transform(from input: Input) -> Output {
            
        let fetchedUser = input.viewWillAppear
            .flatMap(self.userUseCase.fetchUser)
            .compactMap { result -> User? in
                guard case let .success(user) = result else { return nil }
                return user
            }
            .share()
        
        let showEditProfileScene = input.didTapProfileCell
            .withLatestFrom(fetchedUser)
            
        
        let loginType = input.viewDidLoad
            .map(self.userUseCase.fetchLoginType)
        
        let showMyDrinkStampButton = input.didTapMyDrinkStampButton
            .withLatestFrom(fetchedUser)
        
        let showMyPageAlertView = input.didTapMyPagaItem
            .filter{ $0 == .logout || $0 == .withdrawal }
        
        let showPersonalPolicy = input.didTapMyPagaItem
            .filter { $0 == .privacyPolicy }
            .mapToVoid()
        
        let showTermsOfServce = input.didTapMyPagaItem
            .filter { $0 == .termsOfService }
            .mapToVoid()
        
        let showQnnectInstagram = input.didTapMyPagaItem
            .filter{ $0 == .instagram }
            .mapToVoid()
        
        let showSendedQuestionListScene = input.didTapSendedQuestionButton
            
        
        return Output(
            showEditProfileScene: showEditProfileScene.asSignal(onErrorSignalWith: .empty()),
            user: fetchedUser.asDriver(onErrorDriveWith: .empty()),
            loginType: loginType.asDriver(onErrorJustReturn: .unknown),
            showMyDrinkStampButton: showMyDrinkStampButton.asSignal(onErrorSignalWith: .empty()),
            showMyPageAlertView: showMyPageAlertView.asSignal(onErrorSignalWith: .empty()),
            showPersonalPolicy: showPersonalPolicy.asSignal(onErrorSignalWith: .empty()),
            showTermsOfService: showTermsOfServce.asSignal(onErrorSignalWith: .empty()),
            showQnnectInstagram: showQnnectInstagram.asSignal(onErrorSignalWith: .empty()),
            showSendedQuestionListScene: showSendedQuestionListScene.asSignal(onErrorSignalWith: .empty())
        )
    }
}
