//
//  GroupRoomViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/22.
//

import Foundation
import RxSwift
import RxCocoa

final class CafeRoomViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let viewWillAppear: Observable<Void>
        let cafeId: Observable<Int>
    }
    
    struct Output {
        let roomInfo: Driver<Cafe>
    }
    
    private weak var coordinator: CafeCoordinator?
    private let cafeUseCase: CafeUseCase
    
    init(
        coordinator: CafeCoordinator,
        cafeUseCase: CafeUseCase
    ) {
        self.coordinator = coordinator
        self.cafeUseCase = cafeUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let roomInfo = input.viewWillAppear
            .withLatestFrom(input.cafeId)
            .flatMap(self.cafeUseCase.fetchCafe(forId:))
            .compactMap { result -> Cafe? in
                guard case let .success(cafe) = result else { return nil }
                return cafe
            }
            // .do(방 정보를 가져옴)
            // 만약 내가 선택한 음료가 없으면
//            .do(onNext: self.showSelectDrinkBottomSheet)
//                .delaySubscription(RxTimeInterval.seconds(3), scheduler: MainScheduler.instance)
        return Output(
            roomInfo: roomInfo.asDriver(onErrorDriveWith: .empty())
        )
    }
}

private extension CafeRoomViewModel {
    func showSelectDrinkBottomSheet() {
        self.coordinator?.showSelectDrinkBottomSheet()
    }
}
