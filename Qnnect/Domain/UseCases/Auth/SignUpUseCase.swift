//
//  TextUseCase.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/14.
//

import Foundation

protocol SignUpUseCase: InputUseCase {
    func isEssentialItemChecked(_ items: (Bool,Bool,Bool)) -> Bool
    func isAllAgreement(_ items: (Bool,Bool,Bool)) -> Bool
}

final class DefaultSignUpUseCase: SignUpUseCase {
    func isEssentialItemChecked(_ items: (Bool,Bool,Bool)) -> Bool {
        if items.0,items.1 {
            return true
        } else {
            return false
        }
    }
    
    func isAllAgreement(_ items: (Bool,Bool,Bool)) -> Bool {
        return (items.0 && items.1 && items.2)
    }
}

