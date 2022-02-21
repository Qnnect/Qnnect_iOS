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
}

extension InputUseCase {
    func isVaildName(_ name: String) -> Bool {
        let length = name.count
        return length >= 2 && length <= 8 ? true : false
    }
    
    func getNameLength(_ name: String) -> Int {
        return name.count
    }
    
}

final class DefaultInputUseCase: InputUseCase { }
