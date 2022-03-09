//
//  AttachingImageCell.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/09.
//

import UIKit
import SnapKit
import Then
import Photos

protocol AttachingImageCellDelegate: AnyObject {
    func attachingImageCell(didTap cell: UICollectionViewCell)
}

final class AttachingImageCell: UICollectionViewCell {
    
    static let identifier = "AttachingImageCell"
    weak var delegate: AttachingImageCellDelegate?
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.layer.cornerRadius = 12.0
        $0.clipsToBounds = true
    }
    
    private let attachingCancleButton = UIButton().then {
        $0.setImage(Constants.attacingCancleButtonIcon, for: .normal)
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
            self.imageView,
            self.attachingCancleButton
        ].forEach {
            self.contentView.addSubview($0)
        }
        
        self.imageView.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
            make.width.height.equalTo(74.0)
        }
        
        self.attachingCancleButton.snp.makeConstraints { make in
            make.width.height.equalTo(24.0)
            make.centerX.equalTo(self.imageView.snp.trailing)
            make.centerY.equalTo(self.imageView.snp.top)
        }
        
        self.attachingCancleButton.addTarget(self, action: #selector(didTapAttachingCancleButton), for: .touchUpInside)
    }
    
    func update(with asset: PHAsset) {
        let imageManager = PHImageManager()
        let scale = UIScreen.main.scale
        let imageSize = CGSize(width: 74 * scale, height: 74 * scale)
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFill, options: options) { image, info in
            self.imageView.image = image
        }
    }
    
    @objc func didTapAttachingCancleButton() {
        delegate?.attachingImageCell(didTap: self)
    }
}
