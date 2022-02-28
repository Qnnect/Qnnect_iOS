//
//  GroupRoomViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/22.
//

import Foundation
import RxSwift
import RxCocoa

final class GroupRoomViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        //TODO: 수정 필요
        let roomInfo: Driver<Void>
    }
    
    private weak var coordinator: GroupCoordinator?
    
    init(
        coordinator: GroupCoordinator
    ) {
        self.coordinator = coordinator
    }
    
    func transform(from input: Input) -> Output {
        
        let roomInfo = input.viewDidLoad
            // .do(방 정보를 가져옴)
            // 만약 내가 선택한 음료가 없으면
            .do(onNext: self.showSelectDrinkBottomSheet)
                .delaySubscription(RxTimeInterval.seconds(3), scheduler: MainScheduler.instance)
        return Output(
            roomInfo: roomInfo.asDriver(onErrorDriveWith: .empty())
        )
    }
}

private extension GroupRoomViewModel {
    func showSelectDrinkBottomSheet() {
        self.coordinator?.showSelectDrinkBottomSheet()
    }
}
