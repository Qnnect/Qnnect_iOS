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
        let inviteCafeCode: Observable<String>
    }
    
    struct Output {
        let showAddGroupBottomSheet: Signal<Void>
        let curQuestionPage: Driver<Int>
        let showCafeRoom: Signal<Int>
        let homeInfo: Driver<HomeInfo>
        let showJoinCafeBottomSheet: Signal<Void>
        ///Int: QuestionId
        let showCafeQuestionScene: Signal<Int>
        let alreadyInRoom: Signal<JoinCafeError>
    }
    
    private weak var coordinator: HomeCoordinator?
    private let homeUseCase: HomeUseCase
    private let cafeUseCase: CafeUseCase
    
    init(
         homeUseCase: HomeUseCase,
         cafeUseCase: CafeUseCase
    ) {
        self.homeUseCase = homeUseCase
        self.cafeUseCase = cafeUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let showAddGroupBottomSheet = input.didTapAddGroupButton
 
        let homeInfo = input.viewWillAppear
            .flatMap(self.homeUseCase.fetchHomeInfo)
            .debug()
            .compactMap { result -> HomeInfo? in
                guard case let .success(homeInfo) = result else { return nil }
                return homeInfo
            }
        
        let showJoinCafeBottomSheet = input.didTapJoinCafeButton

        
        let showCafeQuestionScene = input.didTapTodayQuestion
            .map {$0.cafeQuestionId}

        //딥링크
        let joinCafeResult = input.inviteCafeCode
            .flatMap(cafeUseCase.joinCafe)
            .share()
        
        let joinCafe = joinCafeResult
            .compactMap {
                result -> Int? in
                guard case let .success(cafe) = result else { return nil }
                return cafe
            }
        
    
        let alreadyInRoom = joinCafeResult
            .compactMap { result -> JoinCafeError? in
                guard case let .failure(error) = result else { return nil }
                if error == .alreadyIn {
                    return error 
                } else {
                    return nil
                }
            }
        
        
        let showCafeRoom = Observable.merge(
            joinCafe,
            input.didTapMyCafe
                .map {$0.id}
        )
        
        
        return Output(
            showAddGroupBottomSheet: showAddGroupBottomSheet.asSignal(onErrorSignalWith: .empty()),
            curQuestionPage: input.curQuestionPage.asDriver(onErrorJustReturn: 0),
            showCafeRoom: showCafeRoom.asSignal(onErrorSignalWith: .empty()),
            homeInfo: homeInfo.asDriver(onErrorDriveWith: .empty()),
            showJoinCafeBottomSheet: showJoinCafeBottomSheet.asSignal(onErrorSignalWith: .empty()),
            showCafeQuestionScene: showCafeQuestionScene.asSignal(onErrorSignalWith: .empty()),
            alreadyInRoom: alreadyInRoom.asSignal(onErrorSignalWith: .empty())
        )
    }
}
