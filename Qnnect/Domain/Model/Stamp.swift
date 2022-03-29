//
//  Stamp.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/29.
//

import Foundation

struct Stamp: Equatable {
    let cafeName: String
    let drinkName: String
    
    static var empty: Stamp {
        return Stamp(cafeName: "", drinkName: "")
    }
    
    public static func == (lhs: Stamp, rhs: Stamp) -> Bool {
        if lhs.cafeName == rhs.cafeName, lhs.drinkName == rhs.drinkName {
            return true
        }
        return false
    }
    
}
