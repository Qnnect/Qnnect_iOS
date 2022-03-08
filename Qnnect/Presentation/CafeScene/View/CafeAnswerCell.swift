//
//  CafeAnswerCell.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/08.
//

import UIKit
import SnapKit
import Then

final class CafeAnswerCell: UITableViewCell {
    static let identifier = "CafeAnswerCell"
    
    private let writerProfileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let writerNameLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 14.0)
        $0.textColor = .BLACK_121212
    }
    
    private let contentLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 13.0)
        $0.textColor = .GRAY01
        $0.numberOfLines = 0
    }
    
    private let attachedImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 16.0
    }
    
    private let commentImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = Constants.commentIcon
    }
    
    private let commentCountLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 12.0)
        $0.textColor = .orange
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureUI() {
        
        [
            self.writerProfileImageView,
            self.writerNameLabel,
            self.contentLabel,
            self.attachedImageView,
            self.commentImageView,
            self.commentCountLabel
        ].forEach {
            self.contentView.addSubview($0)
        }
        
        self.writerProfileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(21.0)
            make.top.equalToSuperview()
            make.width.height.equalTo(27.0)
        }
        
        self.writerNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.writerProfileImageView.snp.trailing).offset(8.0)
            make.centerY.equalTo(self.writerProfileImageView)
        }
        
        self.contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.writerProfileImageView)
            make.top.equalTo(self.writerProfileImageView.snp.bottom).offset(10.0)
        }
        
        self.attachedImageView.snp.makeConstraints { make in
            make.leading.equalTo(self.contentLabel.snp.trailing).offset(12.0)
            make.width.height.equalTo(76.0)
            make.trailing.equalToSuperview().inset(20.0)
        }
        
        self.commentCountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.attachedImageView)
            make.top.equalTo(self.commentImageView)
        }
        
        self.commentImageView.snp.makeConstraints { make in
            make.trailing.equalTo(self.commentCountLabel.snp.leading).offset(-6.0)
            make.top.equalTo(self.attachedImageView.snp.bottom).offset(11.0)
            make.bottom.equalToSuperview()
        }
    }
}
