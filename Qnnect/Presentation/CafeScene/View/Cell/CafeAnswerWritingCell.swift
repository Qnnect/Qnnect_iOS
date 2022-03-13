//
//  CafeAnswerWritingCell.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/08.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class CafeAnswerWritingCell: UITableViewCell {
    static let identifier = "CafeAnswerWritingCell"
    
    private let writerProfileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 27.0 / 2.0
        $0.clipsToBounds = true
    }
    
    private let writerNameLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 14.0)
        $0.textColor = .BLACK_121212
    }
    
    private let mainLabel = UILabel().then {
        $0.text = "질문에 답해보세요!"
        $0.font = .IM_Hyemin(.bold, size: 14.0)
        $0.textColor = .GRAY04
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
    
    private func configureUI() {
        
        [
            self.writerProfileImageView,
            self.writerNameLabel,
            self.mainLabel
        ].forEach {
            self.contentView.addSubview($0)
        }
        
        self.contentView.backgroundColor = .p_ivory
        
        self.writerProfileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(21.0)
            make.top.equalToSuperview().inset(14.0)
            make.width.height.equalTo(27.0)
        }
        
        self.writerNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.writerProfileImageView.snp.trailing).offset(8.0)
            make.centerY.equalTo(self.writerProfileImageView)
        }
        
        self.mainLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.bottom.equalToSuperview().inset(14.0)
        }
    }
    
    func update(with user: User) {
        if let url = user.profileImage {
            self.writerProfileImageView.kf.setImage(
                with: URL(string: url),
                placeholder: Constants.profileDefaultImage
            )
        } else {
            writerProfileImageView.image = Constants.profileDefaultImage
        }
        self.writerNameLabel.text = user.name
    }
}
