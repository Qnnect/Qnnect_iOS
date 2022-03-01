//
//  InputUseCase.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/21.
//

import Foundation

protocol InputUseCase: AnyObject {
    func isVaildName(_ name: String) -> Bool
    func getNameLength(_ name: String) -> Int
    func isEssentialItemChecked(_ items: (Bool,Bool,Bool)) -> Bool
    func isAllAgreement(_ items: (Bool,Bool,Bool)) -> Bool
}

final class DefaultInputUseCase: InputUseCase {
    func isVaildName(_ name: String) -> Bool {
        let length = name.count
        return length >= 2 && length <= 8 ? true : false
    }
    
    func getNameLength(_ name: String) -> Int {
        return name.count
    }
    
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
