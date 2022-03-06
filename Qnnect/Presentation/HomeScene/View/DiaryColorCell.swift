//
//  DiaryColorCell.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/22.
//

import UIKit
import SnapKit
import Then

final class DiaryColorCell: UICollectionViewCell {
    
    static let identifier = "DiaryColorCell"
    
    private(set) var type: DiaryColorType?
    
    private let colorImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    var isChosen: Bool = false {
        didSet {
            self.colorImageView.image = isChosen ? UIImage(named: type?.selectedImageName ?? "") : UIImage(named: type?.defaultImageName ?? "")
        }
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
        self.contentView.addSubview(self.colorImageView)
        
        self.colorImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func update(with type: DiaryColorType) {
        self.type = type
        self.colorImageView.image = UIImage(named: type.defaultImageName)
    }

}
