//
//  CommentAttachImageCell.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/15.
//

import UIKit
import SnapKit
import Then

final class CommentAttachImageCell: UICollectionViewCell {
    static let identifier = "CommentAttachImageCell"
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 16.0
        $0.clipsToBounds = true
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
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func update(with imageURL: String) {
        imageView.kf.setImage(
            with: URL(string: imageURL),
            placeholder: Constants.commentEmptyImage
        )
    }
}
