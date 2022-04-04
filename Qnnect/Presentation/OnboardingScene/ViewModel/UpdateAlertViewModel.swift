//
//  UpdateAlertViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/04/03.
//

import Foundation
import RxSwift
import RxCocoa

final class UpdateAlertViewModel: ViewModelType {
    
    struct Input {
        let didTapAppStoreButton: Observable<Void>
    }
    
    struct Output {
        let showAppStore: Signal<Void>
    }
    
    func transform(from input: Input) -> Output {
        
        let showAppStore = input.didTapAppStoreButton
            .do {
                _ in
                if UIApplication.shared.canOpenURL(URL(string: APP.appStoreLink)!) {
                    UIApplication.shared.open(URL(string: APP.appStoreLink)!, options: [:], completionHandler: nil)
                } else {
                    print("can't open app store url")
                }
            }
        
        return Output(
            showAppStore: showAppStore.asSignal(onErrorSignalWith: .empty())
        )
    }
}
