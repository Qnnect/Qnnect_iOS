//
//  HomeViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/14.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelType {
    
    struct Input {
        let didTapAddGroupButton: Observable<Void>
        let curQuestionPage: Observable<Int>
        let viewWillAppear: Observable<Void>
        let didTapMyCafe: Observable<MyCafe>
        let didTapJoinCafeButton: Observable<Void>
        let didTapTodayQuestion: Observable<ToDayQuestion>
    }
    
    struct Output {
        let showAddGroupBottomSheet: Signal<Void>
        let curQuestionPage: Driver<Int>
        let showCafeRoom: Signal<(Int, Bool)>
        let homeInfo: Driver<HomeInfo>
        let showJoinCafeBottomSheet: Signal<Void>
        let showCafeAnswerScene: Signal<Int>
    }
    
    private weak var coordinator: HomeCoordinator?
    private let homeUseCase: HomeUseCase
    
    init(homeUseCase: HomeUseCase) {
        self.homeUseCase = homeUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let showAddGroupBottomSheet = input.didTapAddGroupButton
 
        
        let showCafeRoom = input.didTapMyCafe
            .map {($0.id,false)}

        
        let homeInfo = input.viewWillAppear
            .flatMap(self.homeUseCase.fetchHomeInfo)
            .debug()
            .compactMap { result -> HomeInfo? in
                guard case let .success(homeInfo) = result else { return nil }
                return homeInfo
            }
        
        let showJoinCafeBottomSheet = input.didTapJoinCafeButton

        
        let showCafeAnswerScene = input.didTapTodayQuestion
            .map {$0.cafeQuestionId}
        
        return Output(
            showAddGroupBottomSheet: showAddGroupBottomSheet.asSignal(onErrorSignalWith: .empty()),
            curQuestionPage: input.curQuestionPage.asDriver(onErrorJustReturn: 0),
            showCafeRoom: showCafeRoom.asSignal(onErrorSignalWith: .empty()),
            homeInfo: homeInfo.asDriver(onErrorDriveWith: .empty()),
            showJoinCafeBottomSheet: showJoinCafeBottomSheet.asSignal(onErrorSignalWith: .empty()),
            showCafeAnswerScene: showCafeAnswerScene.asSignal(onErrorSignalWith: .empty())
        )
    }
}
