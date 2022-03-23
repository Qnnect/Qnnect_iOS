//
//  BlockedFriendCell.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/24.
//

import UIKit
import SnapKit
import Then

@objc
protocol BlockedFriendCellDelegate: AnyObject {
    func didTapReleaseButton(didTap cell: UITableViewCell, reportId: Int)
}

final class BlockedFriendCell: UITableViewCell {
    static let identifier = "BlockedFriendCell"
    
    private let nameLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 14.0)
        $0.textColor = .black
    }
    
    private let releaseButton = UIButton().then {
        $0.setTitle("해제", for: .normal)
        $0.setTitleColor(.GRAY01, for: .normal)
        $0.backgroundColor = .p_ivory
        $0.layer.borderColor = UIColor.brownBorderColor?.cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 15.0
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 12.0)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        delegate = nil
        reportUser = nil
    }
    
    weak var delegate: BlockedFriendCellDelegate?
    private var reportUser: ReportUser?
    
    private func configureUI() {
        
        [
            nameLabel,
            releaseButton
        ].forEach {
            contentView.addSubview($0)
        }
        
        contentView.backgroundColor = .p_ivory
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20.0)
        }
        
        releaseButton.snp.makeConstraints { make in
            make.width.equalTo(47.0)
            make.height.equalTo(30.0)
            make.top.bottom.equalToSuperview().inset(10.0)
            make.trailing.equalToSuperview().inset(20.0)
        }
        releaseButton.addTarget(self, action: #selector(didTapReleaseButton), for: .touchUpInside)
    }
    
    func update(with user: ReportUser) {
        self.reportUser = user
        nameLabel.text = user.nickName
    }
    
    @objc private func didTapReleaseButton() {
        delegate?.didTapReleaseButton(didTap: self, reportId: reportUser?.reportId ?? -1)
    }
}
