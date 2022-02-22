//
//  AddGroupUseCase.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/22.
//

import Foundation

protocol AddGroupUseCase: AnyObject {
    func isValidName(_ name: String) -> Bool
    func adjustQuestionCycle(_ value: Float) -> Int
}

final class DefaultAddGroupUseCase: AddGroupUseCase {

    func isValidName(_ name: String) -> Bool {
        
        return false
    }
    
    func adjustQuestionCycle(_ value: Float) -> Int {
        
        return 0
    }
}
