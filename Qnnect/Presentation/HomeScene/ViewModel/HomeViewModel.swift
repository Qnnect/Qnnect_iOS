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
    }
    
    struct Output {
        let showAddGroupBottomSheet: Signal<Void>
        let curQuestionPage: Driver<Int>
        let showCafeRoom: Signal<Void>
        let homeInfo: Driver<HomeInfo>
        let showJoinCafeBottomSheet: Signal<Void>
    }
    
    private weak var coordinator: HomeCoordinator?
    private let homeUseCase: HomeUseCase
    
    init(
        coordinator:HomeCoordinator,
        homeUseCase: HomeUseCase
    ) {
        self.coordinator = coordinator
        self.homeUseCase = homeUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let showAddGroupBottomSheet = input.didTapAddGroupButton
            .do{ [weak self] _ in
                self?.coordinator?.showAddGroupBottomSheet()
            }
        
        let showCafeRoom = input.didTapMyCafe
            .do {
                [weak self] myCafe in
                self?.coordinator?.showGroupScene(with: myCafe.id, false)
            }
            .mapToVoid()
        
        let homeInfo = input.viewWillAppear
            .flatMap(self.homeUseCase.fetchHomeInfo)
            .debug()
            .compactMap { result -> HomeInfo? in
                guard case let .success(homeInfo) = result else { return nil }
                return homeInfo
            }
        
        let showJoinCafeBottomSheet = input.didTapJoinCafeButton
            .do {
                [weak self] _ in
                self?.coordinator?.showJoinCafeBottomSheet()
            }
        
        return Output(
            showAddGroupBottomSheet: showAddGroupBottomSheet.asSignal(onErrorSignalWith: .empty()),
            curQuestionPage: input.curQuestionPage.asDriver(onErrorJustReturn: 0),
            showCafeRoom: showCafeRoom.asSignal(onErrorSignalWith: .empty()),
            homeInfo: homeInfo.asDriver(onErrorDriveWith: .empty()),
            showJoinCafeBottomSheet: showJoinCafeBottomSheet.asSignal(onErrorSignalWith: .empty())
        )
    }
}
