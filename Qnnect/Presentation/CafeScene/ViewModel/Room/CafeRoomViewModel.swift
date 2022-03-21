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
        let viewDidAppear: Observable<Void>
        let didTapNavigationMenu: Observable<Void>
        let didTapQuestionCell: Observable<Question>
        let didTapQuestionListButton: Observable<Void>
        let didTapDrinkSection: Observable<Void>
    }
    
    struct Output {
        let roomInfo: Driver<Cafe>
        ///Int: CafeId
        let showDrinkSelectGuideAlertView: Signal<(UserBehaviorType, Int)>
        ///Int: CafeId
        let showDrinkSelectBottomSheet: Signal<Int>
        ///Int: CafeId
        let showSettingBottomSheet: Signal<Cafe>
        ///Int: QuestionId
        let showCafeQuestionScene: Signal<Int>
        ///Int: CafeId
        let showWriteQuestionScene: Signal<Int>
        ///Int: CafeId
        let showCafeQuestionListScene: Signal<Int>
        let showOurCafeScene: Signal<(cafeId: Int, cafeUserId: Int)>
    }
    
    private let cafeUseCase: CafeUseCase
    
    init(
        cafeUseCase: CafeUseCase
    ) {
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
        
        let showDrinkSelectBottomSheet = input.didTapDrinkSelectButton
            .withLatestFrom(input.cafeId)
            
        
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
        
        let showSettingBottomSheet = input.didTapNavigationMenu
            .withLatestFrom(roomInfo)
            
        
        let showCafeQuestionScene = input.didTapQuestionCell
            .map { $0.id }
        
        let showWriteQuestionScene = input.didTapQuestionButton
            .withLatestFrom(input.cafeId)
         
        let showCafeQuestionListScene = input.didTapQuestionListButton
            .withLatestFrom(input.cafeId)
        
        let showOurCafeScene = input.didTapDrinkSection
            .withLatestFrom(roomInfo)
            .map { (cafeId: $0.cafeId, cafeUserId: $0.cafeUserId) }
        
        return Output(
            roomInfo: roomInfo.asDriver(onErrorDriveWith: .empty()),
            showDrinkSelectGuideAlertView: showDrinkSelectGuideAlertView.asSignal(onErrorSignalWith: .empty()),
            showDrinkSelectBottomSheet: showDrinkSelectBottomSheet.asSignal(onErrorSignalWith: .empty()),
            showSettingBottomSheet: showSettingBottomSheet.asSignal(onErrorSignalWith: .empty()),
            showCafeQuestionScene: showCafeQuestionScene.asSignal(onErrorSignalWith: .empty()),
            showWriteQuestionScene: showWriteQuestionScene.asSignal(onErrorSignalWith: .empty()),
            showCafeQuestionListScene: showCafeQuestionListScene.asSignal(onErrorSignalWith: .empty()),
            showOurCafeScene: showOurCafeScene.asSignal(onErrorSignalWith: .empty())
        )
    }
}


