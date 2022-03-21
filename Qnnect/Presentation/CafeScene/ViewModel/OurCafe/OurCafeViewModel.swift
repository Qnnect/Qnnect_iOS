//
//  OutCafeViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/17.
//

import Foundation
import RxSwift
import RxCocoa

final class OurCafeViewModel: ViewModelType {
    
    struct Input {
        let cafeId: Observable<Int>
        let cafeUserId: Observable<Int>
        let viewDidLoad: Observable<Void>
        let viewWillAppear: Observable<Void>
        let didTapOurCafeUserCell: Observable<OurCafeUser>
        let didTapInsertIngredientButton: Observable<Void>
        let didTapStoreButton: Observable<Void>
        let didTapSelectDrinkButton: Observable<Void>
    }
    
    struct Output {
        let userInfos: Driver<[OurCafeUser]>
        let isCurrentUser: Driver<(Bool, String)>
        let curStep: Driver<DrinkStep>
        let drinkState: Driver<[(target: Int, filled: Int)]>
        ///Int: CafeId
        let showInsertIngredientScene: Signal<Int>
        let showStoreScene: Signal<Void>
        let isUserDrinkFetched: Signal<Bool>
        let isDrinkCompleted: Signal<Bool>
        /// Int: CafeId
        let showSelectDrinkScene: Signal<Int>
        let drinkName: Driver<String>
    }
    
    private let ourCafeUseCase: OurCafeUseCase
    
    init(ourCafeUseCase: OurCafeUseCase) {
        self.ourCafeUseCase = ourCafeUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let firstLoad = input.viewDidLoad.withLatestFrom(
            Observable.combineLatest(
                input.cafeId,
                input.cafeUserId,
                resultSelector: {(cafeId: $0, cafeUserId: $1)}
            )
        ).flatMap(ourCafeUseCase.fetchOurCafe)
            .share()
        
        let firstLoadUserInfos = firstLoad
            .compactMap { result -> OurCafe? in
                guard case let .success(cafe) = result else { return nil }
                return cafe
            }.map { $0.cafeUsers }
        
        let load = Observable.merge(
            input.viewWillAppear
                .skip(1)
                .withLatestFrom(
                    Observable.combineLatest(
                        input.cafeId,
                        input.cafeUserId,
                        resultSelector: {(cafeId: $0, cafeUserId: $1)}
                    )
                ),
            input.didTapOurCafeUserCell
                .map { $0.cafeUserId }
                .withLatestFrom(input.cafeId, resultSelector: {(cafeId: $1, cafeUserId: $0)})
                .share()
        )
            .flatMap(ourCafeUseCase.fetchOurCafe)
            .share()
        
        
        let fetchedResult = Observable.merge(load, firstLoad)
        
        let ourCafe = fetchedResult
            .compactMap { result -> OurCafe? in
                guard case let .success(ourCafe) = result else { return nil }
                return ourCafe
            }
        
        let isDrinkCompleted = fetchedResult
            .map {
                [weak self] result -> Bool in
                if case let .success(cafe) = result {
                    if let curStep = self?.ourCafeUseCase.getCurStep(cafe.selectedUserDrinkInfo),
                       curStep == .completed {
                        return true
                    }
                }
                return false
            }
        
        let isUserDrinkFetched = fetchedResult
            .map {
                result -> Bool in
                if case .success(_) = result {
                    return true
                } else {
                    return false
                }
            }
        
        
        
        let curStep = ourCafe.map { $0.selectedUserDrinkInfo }
            .map(ourCafeUseCase.getCurStep(_:))
        
        let drinkState = ourCafe.map { $0.selectedUserDrinkInfo }
            .map {
                drink -> [(target: Int, filled: Int)] in
                var drinkState = [(target: Int, filled: Int)]()
                drinkState.append((target:drink.ice, filled: drink.iceFilled))
                drinkState.append((target:drink.base, filled: drink.baseFilled))
                drinkState.append((target:drink.main, filled: drink.mainFilled))
                drinkState.append((target:drink.topping, filled: drink.toppingFilled))
                return drinkState
            }
        
        let showInsertIngredientScene = input.didTapInsertIngredientButton
            .withLatestFrom(input.cafeId)
        
        let showSelectDrinkScene = input.didTapSelectDrinkButton
            .withLatestFrom(input.cafeId)
        
        let drinkName = ourCafe.map { $0.selectedUserDrinkInfo.userDrinkName }
        
        return Output(
            userInfos: firstLoadUserInfos
                .withLatestFrom(input.cafeUserId, resultSelector: { ($0, $1) })
                .map {
                    // MARK: -  현재 유저가 맨 처음으로 오게 수정하는 로직
                    (users, userId) in
                    var newUsers = users
                    let index = users.firstIndex(where: { user in user.cafeUserId == userId })
                    let myUser = newUsers.remove(at: Int(index!))
                    newUsers = [myUser] + newUsers
                    return newUsers
                }
                .asDriver(onErrorDriveWith: .empty()),
            isCurrentUser: ourCafe.map { $0.currentUser }
                .withLatestFrom(
                    input.didTapOurCafeUserCell.map {$0.nickName}
                    ,resultSelector: { ($0,$1)}
                )
                .asDriver(onErrorDriveWith: .empty()),
            curStep: curStep.asDriver(onErrorJustReturn: .ice),
            drinkState: drinkState.asDriver(onErrorJustReturn: []),
            showInsertIngredientScene: showInsertIngredientScene.asSignal(onErrorSignalWith: .empty()),
            showStoreScene: input.didTapStoreButton.asSignal(onErrorSignalWith: .empty()),
            isUserDrinkFetched: isUserDrinkFetched.asSignal(onErrorSignalWith: .empty()),
            isDrinkCompleted: isDrinkCompleted.asSignal(onErrorSignalWith: .empty()),
            showSelectDrinkScene: showSelectDrinkScene.asSignal(onErrorSignalWith: .empty()),
            drinkName: drinkName.asDriver(onErrorDriveWith: .empty())
        )
    }
}
