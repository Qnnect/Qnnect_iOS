//
//  AddGroupUseCase.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/22.
//

import Foundation

protocol AddGroupUseCase: AnyObject {
    func isValidName(_ name: String) -> Bool
}

final class DefaultAddGroupUseCase: AddGroupUseCase {

    func isValidName(_ name: String) -> Bool {
        let length = name.count
        return length >= 2 && length <= 10 ? true : false
    }
}
