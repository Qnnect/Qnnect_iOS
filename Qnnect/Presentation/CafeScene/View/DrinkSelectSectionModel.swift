//
//  DrinkSelectSectionModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/11.
//

import Foundation
import Differentiator

struct DrinkSelectSectionModel {
    var items: [Item]
}

extension DrinkSelectSectionModel: SectionModelType {
    typealias Item = Drink
    
    init(original: DrinkSelectSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
