//
//  InviteCafeViewModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/21.
//

import Foundation
import RxSwift
import RxCocoa
import RxKakaoSDKLink
import KakaoSDKLink

final class InviteCafeViewModel: ViewModelType {
    
    struct Input {
        let cafe: Observable<Cafe>
        let didTapCodeCopyButton: Observable<Void>
        let didTapKakaoInvitationButton: Observable<Void>
    }
    
    struct Output {
        let invite: Signal<LinkResult>
        let copy: Signal<String>
    }
    
    
    func transform(from input: Input) -> Output {
        
        let invite = input.didTapKakaoInvitationButton
            .withLatestFrom(input.cafe)
            .flatMap {
                LinkApi.shared.rx.customLink(
                    templateId: 73322,
                    templateArgs:[
                        "code": $0.code,
                        "group_name": $0.title
                    ]
                )
            }
        
        let copy = input.didTapCodeCopyButton
            .withLatestFrom(input.cafe.map { $0.code } )
            
        
        return Output(
            invite: invite.asSignal(onErrorSignalWith: .empty()),
            copy: copy.asSignal(onErrorSignalWith: .empty())
        )
    }
}
