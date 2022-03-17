//
//  StorageSectionModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/18.
//

import Foundation
import RxDataSources

enum StorageSectionModel {
    case IngredientSection(title: String, items: [StorageSectionItem])
}

enum StorageSectionItem {
    case IngredientSectionItem(ingredient: MyIngredient)
}

extension StorageSectionModel: SectionModelType {
    init(original: StorageSectionModel, items: [StorageSectionItem]) {
        switch original {
        case .IngredientSection(title: let title, _):
            self = .IngredientSection(title: title, items: items)
      
        }
    }
    
    typealias Item = StorageSectionItem
    
    var items: [Item] {
        switch self {
        case .IngredientSection(_, let items):
            return items
        }
    }
    
}
