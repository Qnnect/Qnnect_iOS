//
//  CafeDrinksSectionBackgroundView.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/06.
//

import UIKit
import SnapKit
import Then



final class CafeDrinksSectionDecorationView: UICollectionReusableView {
    static let identifier = "CafeDrinksSectionBackgroundView"
    
    private let insetView = UIView().then {
        $0.layer.cornerRadius = 16.0
        $0.layer.borderWidth = 1.0
        $0.backgroundColor = .secondaryBackground
        $0.layer.borderColor = UIColor.groupDrinksBorder?.cgColor
        
    }
    
    private(set) var emptyLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 12.0)
        $0.textColor = .GRAY03
        $0.text = "아직 참여한 인원이 없습니다."
        $0.isHidden = true
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
        [
            self.insetView,
            self.emptyLabel
        ].forEach {
            self.addSubview($0)
        }
        
        self.insetView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.top.bottom.equalToSuperview()
        }
        
      
        self.emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
