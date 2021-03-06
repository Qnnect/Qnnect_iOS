//
//  CommentCell.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/15.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class CommentCell: UICollectionViewCell {
    static let identifier = "CommentCell"
    
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
    
    private var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        comment = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    private var comment: Comment?
 
    
    private func configureUI() {

        [
            writerProfileImageView,
            writerNameLabel,
            contentLabel
        ].forEach {
            contentView.addSubview($0)
        }
        
        writerProfileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.width.height.equalTo(27.0)
        }
        
        writerNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(writerProfileImageView.snp.trailing).offset(10.0)
            make.centerY.equalTo(writerProfileImageView)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(writerProfileImageView)
            make.trailing.equalToSuperview().inset(24.0)
            make.top.equalTo(writerProfileImageView.snp.bottom).offset(10.0)
            make.bottom.equalToSuperview()
        }
    }
    
    func update(with comment: Comment) {
        self.comment = comment
        writerProfileImageView.kf.setImage(
            with: URL(string: comment.writerInfo.profileImage ?? ""),
            placeholder: Constants.profileDefaultImage
        )
        
        writerNameLabel.text = comment.writerInfo.name
        let paragraphStyle = Constants.paragraphStyle
        paragraphStyle.alignment = .left
        contentLabel.attributedText = NSAttributedString(
            string: comment.content,
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
    }
    func bind(with profileObserver: AnyObserver<User>) {
        Observable.merge(
            writerProfileImageView.rx.tapGesture()
                .when(.recognized).mapToVoid(),
            writerNameLabel.rx.tapGesture()
                .when(.recognized).mapToVoid()
        ).filter {
            [weak self] user in
            if let writer = self?.comment?.writer, writer {
                return false
            }
            return true
        }.compactMap {
            [weak self] _ in
            self?.comment?.writerInfo
        }
            .subscribe(profileObserver)
            .disposed(by: self.disposeBag)
    }
}
