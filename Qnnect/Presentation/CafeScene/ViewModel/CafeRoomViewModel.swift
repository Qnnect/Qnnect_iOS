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
        let didTapQuestionButton: Observable<Void>
        let didTapDrinkSelectButton: Observable<Void>
        let isFirst: Observable<Bool>
    }
    
    struct Output {
        let roomInfo: Driver<Cafe>
        let showDrinkSelectGuideAlertView: Signal<Void>
        let showDrinkSelectBottomSheet: Signal<Void>
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
            .debug()
            .compactMap { result -> Cafe? in
                guard case let .success(cafe) = result else { return nil }
                return cafe
            }
            .share()
            // .do(방 정보를 가져옴)
            // 만약 내가 선택한 음료가 없으면
//            .do(onNext: self.showSelectDrinkBottomSheet)
//                .delaySubscription(RxTimeInterval.seconds(3), scheduler: MainScheduler.instance)
        
        let showDrinkSelectBottomSheet = Observable.merge(input.didTapDrinkSelectButton, input.isFirst.filter{$0}.mapToVoid())
            .do {
                [weak self] _ in
                self?.coordinator?.showSelectDrinkBottomSheet()
            }
        
        let showDrinkSelectGuideAlertView = input.didTapQuestionButton
            .withLatestFrom(roomInfo)
            .map{ $0.currentUser}
            .map(self.cafeUseCase.isDrinkSelected)
            .filter{!$0}
            .do {
                [weak self] _ in
                self?.coordinator?.showDrinkSelectGuideAlertView(.question)
            }
            .mapToVoid()
        
        return Output(
            roomInfo: roomInfo.asDriver(onErrorDriveWith: .empty()),
            showDrinkSelectGuideAlertView: showDrinkSelectGuideAlertView.asSignal(onErrorSignalWith: .empty()),
            showDrinkSelectBottomSheet: showDrinkSelectBottomSheet.asSignal(onErrorSignalWith: .empty())
        )
    }
}

private extension CafeRoomViewModel {
    func showSelectDrinkBottomSheet() {
        self.coordinator?.showSelectDrinkBottomSheet()
    }
}
