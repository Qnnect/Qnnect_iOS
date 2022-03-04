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
    }
    
    struct Output {
        let showEditProfileScene: Signal<Void>
        let user: Driver<User>
    }
    
    private weak var coordinator: MyPageCoordinator?
    private let userUseCase: UserUseCase
    
    init(
        coordinator: MyPageCoordinator,
        userUseCase: UserUseCase
    ) {
        self.coordinator = coordinator
        self.userUseCase = userUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let showEditProfileScene = input.didTapProfileCell
            .do{
                [weak self] _ in
                self?.coordinator?.showEditProfileScene()
            }
            
        let fetchedUser = input.viewWillAppear
            .flatMap(self.userUseCase.fetchUser)
            .compactMap { result -> User? in
                guard case let .success(user) = result else { return nil }
                return user
            }
        
        return Output(
            showEditProfileScene: showEditProfileScene.asSignal(onErrorSignalWith: .empty()),
            user: fetchedUser.asDriver(onErrorDriveWith: .empty())
        )
    }
}
