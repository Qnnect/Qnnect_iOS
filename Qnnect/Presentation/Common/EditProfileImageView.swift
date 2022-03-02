//
//  EditProfileImageView.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/21.
//

import UIKit
import SnapKit
import Then
import Kingfisher
import RxSwift

final class EditProfileImageView: UIView {
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = Constants.profileImageHeight / 2.0
        $0.clipsToBounds = true
    }
    
    private let cameraImageView = UIImageView(image: Constants.cameraImage)
    
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
            self.profileImageView,
            self.cameraImageView
        ].forEach {
            self.addSubview($0)
        }
        
        self.profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.cameraImageView.snp.makeConstraints { make in
            make.trailing.equalTo(self.profileImageView)
            make.bottom.equalTo(self.profileImageView).inset(5.0)
            make.width.height.equalTo(28.0)
        }
    }
    
    func setImage(url: URL?) {
        self.profileImageView.kf.setImage(
            with: url,
            placeholder: Constants.profileDefaultImage
        )
    }
    
    func setImage(image: UIImage?) {
        self.profileImageView.image = image
    }
    
    var imageData: Observable<Data> {
        return self.profileImageView.rx.observe(UIImage.self, "image")
            .map{ $0?.pngData() }
            .compactMap {$0 }
    }
}
