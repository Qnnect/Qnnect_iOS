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
        let viewWillAppear: Observable<Void>
        /// Int: CafeUserId
        let didTapOurCafeUserCell: Observable<Int>
    }
    
    struct Output {
        let userInfos: Driver<[OurCafeUser]>
        let iscurrentUser: Driver<Bool>
        let curStep: Driver<DrinkStep>
        let drinkState: Driver<[(target: Int, filled: Int)]>
    }
    
    private let ourCafeUseCase: OurCafeUseCase
    
    init(ourCafeUseCase: OurCafeUseCase) {
        self.ourCafeUseCase = ourCafeUseCase
    }
    
    func transform(from input: Input) -> Output {
        
        let ourCafe = Observable.merge(
            input.viewWillAppear
                .withLatestFrom(
                    Observable.combineLatest(
                        input.cafeId,
                        input.cafeUserId,
                        resultSelector: {(cafeId: $0, cafeUserId: $1)}
                    )
                ),
            input.didTapOurCafeUserCell
                .withLatestFrom(input.cafeId, resultSelector: {(cafeId: $1, cafeUserId: $0)})
                .share()
            )
            .flatMap(ourCafeUseCase.fetchOurCafe)
            .compactMap { result -> OurCafe? in
                guard case let .success(ourCafe) = result else { return nil }
                return ourCafe
            }.share()
        
        
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
        
        return Output(
            userInfos: ourCafe.map { $0.cafeUsers}.asDriver(onErrorJustReturn: []),
            iscurrentUser: ourCafe.map { $0.currentUser }.asDriver(onErrorDriveWith: .empty()),
            curStep: curStep.asDriver(onErrorJustReturn: .ice),
            drinkState: drinkState.asDriver(onErrorJustReturn: [])
        )
    }
}
