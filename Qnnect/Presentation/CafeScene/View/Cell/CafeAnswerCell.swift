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
        $0.layer.cornerRadius = 13.5
        $0.clipsToBounds = true
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
        $0.clipsToBounds = true
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
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: Constants.answerCellSpacing, right: 0))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        attachedImageView.image = nil
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
        
        contentView.backgroundColor = .p_ivory
        backgroundColor = .p_ivory
        selectionStyle = .none
        
        self.writerProfileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(21.0)
            make.top.equalToSuperview()
            make.width.height.equalTo(27.0)
        }
        
        self.writerNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.writerProfileImageView.snp.trailing).offset(10.0)
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
            make.top.equalTo(contentLabel)
        }
        
        self.commentCountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.attachedImageView)
            make.top.equalTo(self.commentImageView)
        }
        
        self.commentImageView.snp.makeConstraints { make in
            make.trailing.equalTo(self.commentCountLabel.snp.leading).offset(-6.0)
            make.width.height.equalTo(14.0)
            make.top.equalTo(attachedImageView.snp.bottom).offset(8.0)
        }
    }
    
    func update(with comment: Comment) {
        if let url = comment.writerInfo.profileImage {
            self.writerProfileImageView.kf.setImage(
                with: URL(string: url),
                placeholder: Constants.profileDefaultImage
            )
        } else {
            writerProfileImageView.image = Constants.profileDefaultImage
        }
        self.writerNameLabel.text = comment.writerInfo.name
        contentLabel.text = comment.content
        commentCountLabel.text = comment.replyCount != 0 ? "\(comment.replyCount)" : ""
        
        if let url = comment.getImageURLs().first {
            attachedImageView.kf.setImage(
                with: URL(string: url),
                placeholder: Constants.commentEmptyImage
            )
            
            self.commentImageView.snp.remakeConstraints { make in
                make.trailing.equalTo(self.commentCountLabel.snp.leading).offset(-6.0)
                make.width.height.equalTo(14.0)
                make.top.equalTo(attachedImageView.snp.bottom).offset(8.0)
            }
        } else {
            self.commentImageView.snp.remakeConstraints { make in
                make.trailing.equalTo(self.commentCountLabel.snp.leading).offset(-6.0)
                make.width.height.equalTo(14.0)
                make.top.equalTo(contentLabel.snp.bottom).offset(8.0)
            }

        }
    }
}
