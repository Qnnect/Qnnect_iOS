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
        let viewDidAppear: Observable<Void>
        let didTapNavigationMenu: Observable<Void>
        let didTapQuestionCell: Observable<Question>
    }
    
    struct Output {
        let roomInfo: Driver<Cafe>
        let showDrinkSelectGuideAlertView: Signal<Void>
        let showDrinkSelectBottomSheet: Signal<Void>
        let showSettingBottomSheet: Signal<Void>
        let showQuestionAnswerScene: Signal<Void>
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
        
        let showDrinkSelectBottomSheet = Observable.merge(
            input.didTapDrinkSelectButton,
            Observable.zip(
                input.isFirst.filter{$0}.mapToVoid(),
                input.viewDidAppear.delay(RxTimeInterval.milliseconds(5), scheduler: MainScheduler.instance)
            ).mapToVoid()
            )
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
        
        let showSettingBottomSheet = input.didTapNavigationMenu
            .do {
                [weak self] _ in
                self?.coordinator?.showSettingBottomSheet()
            }
        
        let showQuestionAnswerScene = input.didTapQuestionCell
            .do {
                [weak self] question in
                self?.coordinator?.showCafeAnswerScene(question)
            }
            .mapToVoid()
        
        return Output(
            roomInfo: roomInfo.asDriver(onErrorDriveWith: .empty()),
            showDrinkSelectGuideAlertView: showDrinkSelectGuideAlertView.asSignal(onErrorSignalWith: .empty()),
            showDrinkSelectBottomSheet: showDrinkSelectBottomSheet.asSignal(onErrorSignalWith: .empty()),
            showSettingBottomSheet: showSettingBottomSheet.asSignal(onErrorSignalWith: .empty()),
            showQuestionAnswerScene: showQuestionAnswerScene.asSignal(onErrorSignalWith: .empty())
        )
    }
}

private extension CafeRoomViewModel {
    func showSelectDrinkBottomSheet() {
        self.coordinator?.showSelectDrinkBottomSheet()
    }
}
