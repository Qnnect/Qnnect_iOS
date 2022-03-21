//
//  MyDrinkStampSectionModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/22.
//

import Foundation
import RxDataSources

enum MyDrinkStampSectionModel {
    case titleSection(items: [MyDrinkStampSectionItem])
    case stampSection(items: [MyDrinkStampSectionItem])
}

enum MyDrinkStampSectionItem {
    case titleSectionItem(user: User)
    case stampSectionItem(model: StampTestModel)
}

extension MyDrinkStampSectionModel: SectionModelType {
    var items: [MyDrinkStampSectionItem] {
        switch self {
        case .stampSection(items: let items):
            return items
        case .titleSection(items: let items):
            return items
        }
    }
    
    init(original: MyDrinkStampSectionModel, items: [MyDrinkStampSectionItem]) {
        switch original {
        case .titleSection(_):
            self = .titleSection(items: items)
        case .stampSection(_):
            self = .stampSection(items: items)
        }
    }
    
    typealias Item = MyDrinkStampSectionItem
    
}
