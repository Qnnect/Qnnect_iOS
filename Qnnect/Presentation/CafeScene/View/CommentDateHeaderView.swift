//
//  CommentDateHeaderView.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/15.
//

import UIKit
import SnapKit
import Then

final class CommentDateHeaderView: UICollectionReusableView {
    static let identifier = "CommentDateHeaderView"
    
    private let dateLabel = UILabel().then {
        $0.font = .Roboto(.regular, size: 12.0)
        $0.textColor = .GRAY04
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    private func configureUI() {
        addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }

    }
    
    func update(with date: String) {
        dateLabel.text = date
    }
}
