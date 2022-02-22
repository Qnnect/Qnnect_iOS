//
//  SectionHeaderView.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/21.
//

import UIKit
import SnapKit
import Then

final class StoreSectionHeaderView: UICollectionReusableView {
    static let identifier = "StoreSectionHeaderView"
    
    private(set) var tagCollectionView = CustomTagCollectionView().then {
        $0.addWholeTag()
        $0.update(with: IngredientType.allCases.map { $0.title })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
    
    private func configureUI() {
        self.addSubview(self.tagCollectionView)
        
        
        self.tagCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.tagCollectionView.updateTag(at: UInt(0), selected: true)
    }
}
