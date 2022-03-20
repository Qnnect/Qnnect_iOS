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
import Kingfisher

protocol AttachingImageCellDelegate: AnyObject {
    func attachingImageCell(didTap cell: UICollectionViewCell)
}

final class AttachingImageCell: UICollectionViewCell {
    
    static let identifier = "AttachingImageCell"
    weak var delegate: AttachingImageCellDelegate?
    
    private(set) var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
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
    
    func update(with asset: PHAsset, imageLoadCompletion: @escaping (UIImage?) -> Void) {
        let imageManager = PHImageManager()
        let scale = UIScreen.main.scale
        let imageSize = CGSize(width: 300 * scale , height: 300 * scale)
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFill, options: options) {
            [weak self] image, info in
            if (info?[PHImageResultIsDegradedKey] as? Bool) == true{
            }else{
                //고화질
                self?.imageView.image = image
                imageLoadCompletion(image)
            }
        }
    }
    
    func update(with url: String, imageLoadCompletion: @escaping (UIImage?) -> Void) {
        imageView.kf.setImage(
            with: URL(string: url)!,
            placeholder: Constants.commentEmptyImage) {
                [weak self] result in
                imageLoadCompletion(self?.imageView.image)
            }
    }
    
    @objc func didTapAttachingCancleButton() {
        delegate?.attachingImageCell(didTap: self)
    }
}
