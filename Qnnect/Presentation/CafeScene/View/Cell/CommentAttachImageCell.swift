//
//  CommentAttachImageCell.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/15.
//

import UIKit
import SnapKit
import Then

@objc
protocol CommentAttachImageCellDelegate: AnyObject {
    func didTapAttachImageCell(didTap cell: UICollectionViewCell)
}
final class CommentAttachImageCell: UICollectionViewCell {
    static let identifier = "CommentAttachImageCell"
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 16.0
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageView.gestureRecognizers = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    weak var delegate: CommentAttachImageCellDelegate?
    
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
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
        imageView.addGestureRecognizer(tapgesture)
    }
    
    @objc func didTapImageView() {
        delegate?.didTapAttachImageCell(didTap: self)
    }
}
