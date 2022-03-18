//
//  UserSelectSectionModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/18.
//

import Foundation
import RxDataSources

struct UserSelectSectionModel {
    var items: [Item]
}

extension UserSelectSectionModel: SectionModelType {
    typealias Item = OurCafeUser
    
    init(original: UserSelectSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
