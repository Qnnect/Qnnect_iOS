//
//  BookmarkTagCollectionView.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/11.
//

import UIKit

final class BookmarkTagCollectionView: CustomTagCollectionView {
    
    var cafes: [CafeTag]?
    func update(with cafes: [CafeTag]) {
        super.update(with: cafes.map { $0.cafeTitle })
        self.cafes = cafes
    }
}
