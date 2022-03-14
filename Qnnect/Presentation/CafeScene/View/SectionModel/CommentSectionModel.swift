//
//  CommentSectionModel.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/15.
//

import Foundation
import RxDataSources

enum CommentSectionModel {
    case commentSection(title: String, items: [CommentSectionItem])
    case attachImageSection(title: String, items: [CommentSectionItem])
    case replySection(title: String, items: [CommentSectionItem])
}
enum CommentSectionItem {
    case commentSectionItem(comment: Comment)
    case attachImageSectionItem(imageURL: String)
    case replySectionItem(reply: Reply)
}

extension CommentSectionModel: SectionModelType {
    
    init(original: CommentSectionModel, items: [CommentSectionItem]) {
        switch original {
        case .commentSection(title: let title, _):
            self = .commentSection(title: title, items: items)
        case .attachImageSection(title: let title, _):
            self = .attachImageSection(title: title, items: items)
        case .replySection(title: let title, _):
            self = .replySection(title: title, items: items)
        }
    }
    
    typealias Item = CommentSectionItem
    
    var items: [Item] {
        switch self {
        case .commentSection(_, let items):
            return items
        case .attachImageSection(_, let items):
            return items
        case .replySection(_, let items):
            return items
        }
    }
    

}
