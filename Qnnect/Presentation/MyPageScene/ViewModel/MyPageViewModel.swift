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
    }
    
    struct Output {
        let showEditProfileScene: Signal<Void>
    }
    
    private weak var coordinator: MyPageCoordinator?
    
    init(coordinator: MyPageCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(from input: Input) -> Output {
        
        let showEditProfileScene = input.didTapProfileCell
            .do(onNext: {
                [weak self] _ in
                print("profileCell tap!!!")
                self?.coordinator?.showEditProfileScene()
            })
            
                
        return Output(
            showEditProfileScene: showEditProfileScene.asSignal(onErrorSignalWith: .empty())
        )
    }
}
