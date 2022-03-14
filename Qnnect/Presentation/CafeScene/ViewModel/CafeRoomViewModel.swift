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
        let showWriteQuestionScene: Signal<Void>
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
            .withLatestFrom(input.cafeId)
            .do {
                [weak self] cafeId in
                self?.coordinator?.showSelectDrinkBottomSheet(cafeId)
            }
            .mapToVoid()
        
        let showDrinkSelectGuideAlertView = Observable.merge(
            input.didTapQuestionButton.map { _ in UserBehaviorType.question },
            input.didTapQuestionCell.map { _ in UserBehaviorType.answer }
        )
            .withLatestFrom(roomInfo,resultSelector: { (type: $0, cafe: $1) })
            .filter {
                [weak self] in
                self?.cafeUseCase.isDrinkSelected($0.cafe.currentUser) == false
            }
            .map{ $0.type}
            .withLatestFrom(input.cafeId,resultSelector: { ($0, $1) } )
            .do {
                [weak self] type, cafeId in
                self?.coordinator?.showDrinkSelectGuideAlertView(type, cafeId)
            }
            .mapToVoid()
        
        let showSettingBottomSheet = input.didTapNavigationMenu
            .withLatestFrom(input.cafeId)
            .do {
                [weak self] cafeId in
                self?.coordinator?.showSettingBottomSheet(cafeId)
            }
            .mapToVoid()
        
        let showQuestionAnswerScene = input.didTapQuestionCell
            .withLatestFrom(Observable.combineLatest(roomInfo,input.cafeId),resultSelector: {
                return ($0, $1.0.currentUser.userInfo, $1.1)
            })
            .do {
                [weak self] question,user, cafeId in
                self?.coordinator?.showCafeAnswerScene(question.id, user, cafeId)
            }
            .mapToVoid()
        
        let showWriteQuestionScene = input.didTapQuestionButton
            .withLatestFrom(input.cafeId)
            .do {
                [weak self] cafeId in
                self?.coordinator?.showWriteQuestionScene(cafeId)
            }
            .mapToVoid()
        
        return Output(
            roomInfo: roomInfo.asDriver(onErrorDriveWith: .empty()),
            showDrinkSelectGuideAlertView: showDrinkSelectGuideAlertView.asSignal(onErrorSignalWith: .empty()),
            showDrinkSelectBottomSheet: showDrinkSelectBottomSheet.asSignal(onErrorSignalWith: .empty()),
            showSettingBottomSheet: showSettingBottomSheet.asSignal(onErrorSignalWith: .empty()),
            showQuestionAnswerScene: showQuestionAnswerScene.asSignal(onErrorSignalWith: .empty()),
            showWriteQuestionScene: showWriteQuestionScene.asSignal(onErrorSignalWith: .empty())
        )
    }
}


