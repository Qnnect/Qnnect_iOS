//
//  StoreSectionModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/21.
//

import Foundation
import RxDataSources

enum StoreSectionModel {
    case IngredientSection(title: String, items: [StoreSectionItem])
}

enum StoreSectionItem {
    case IngredientSectionItem(Ingredient: Ingredient)
}

extension StoreSectionModel: SectionModelType {
    init(original: StoreSectionModel, items: [StoreSectionItem]) {
        switch original {
        case .IngredientSection(title: let title, _):
            self = .IngredientSection(title: title, items: items)
      
        }
    }
    
    typealias Item = StoreSectionItem
    
    var items: [Item] {
        switch self {
        case .IngredientSection(_, let items):
            return items
        }
    }
    
}
