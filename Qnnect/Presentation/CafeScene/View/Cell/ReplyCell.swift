//
//  ReplyCell.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/15.
//

import UIKit
import SnapKit
import Then
import RxSwift

@objc
protocol ReplyMoreButtonDelegate: AnyObject {
    dynamic func moreButton(didTap cell: UICollectionViewCell, _ replyId: Int)
}

final class ReplyCell: UICollectionViewCell {
    
    static let identifier = "ReplyCell"
    
    weak var delegate: ReplyMoreButtonDelegate?
    private let disposeBag = DisposeBag()
    
    private let arrowImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = Constants.reply_arrow_icon
    }
    
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
        $0.sizeToFit()
    }
    
    private let dateLabel = UILabel().then {
        $0.font = .Roboto(.regular, size: 12.0)
        $0.textColor = .GRAY04
    }
    
    private let moreButton = UIButton().then {
        $0.setImage(Constants.more_icon, for: .normal)
    }
    
    private let outerView = UIView().then {
        $0.backgroundColor = .secondaryBackground
        $0.layer.cornerRadius = 16.0
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.reply_border?.cgColor
    }
    
    private var reply: Reply?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reply = nil
    }
    
    private func configureUI() {
        
        [
            arrowImageView,
            outerView
        ].forEach {
            contentView.addSubview($0)
        }
        
        [
            writerProfileImageView,
            writerNameLabel,
            contentLabel,
            dateLabel,
            moreButton
        ].forEach {
            outerView.addSubview($0)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(outerView).offset(5.0)
            make.width.height.equalTo(15.0)
        }
        
        outerView.snp.makeConstraints { make in
            make.leading.equalTo(arrowImageView.snp.trailing).offset(3.0)
            make.top.bottom.trailing.equalToSuperview()
        }
        
        writerProfileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15.0)
            make.top.equalToSuperview().inset(11.0)
            make.width.height.equalTo(27.0)
        }
        
        writerNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(writerProfileImageView.snp.trailing).offset(10.0)
            make.centerY.equalTo(writerProfileImageView)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(writerProfileImageView)
            make.top.equalTo(writerProfileImageView.snp.bottom).offset(8.0)
        }
        
        moreButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().offset(6.0)
            make.width.height.equalTo(48.0)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12.0)
            make.top.equalTo(contentLabel.snp.bottom).offset(3.0)
            make.bottom.equalToSuperview().inset(9.0)
        }
    }
    
    func update(with reply: Reply) {
        self.reply = reply
        writerProfileImageView.kf.setImage(
            with: URL(string: reply.writerInfo.profileImage ?? ""),
            placeholder: Constants.profileDefaultImage
        )
        
        writerNameLabel.text = reply.writerInfo.name
        contentLabel.attributedText = NSAttributedString(
            string: reply.content,
            attributes: [NSAttributedString.Key.paragraphStyle: Constants.paragraphStyle]
        )
        dateLabel.text = reply.createdAt
        moreButton.isHidden = !reply.writer
        
        moreButton.rx.tap
            .subscribe(onNext: {
                [weak self] _ in
                guard let self = self, let id = self.reply?.id else { return }
                self.delegate?.moreButton(didTap: self, id)
            }).disposed(by: self.disposeBag)
    }
    
}
