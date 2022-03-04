//
//  PointCell.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/21.
//

import UIKit
import SnapKit
import Then

final class PointCell: UITableViewCell {
    static let identifier = "PointCell"
    
    private let pointView = UIView().then {
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.secondaryBorder?.cgColor
        $0.layer.cornerRadius = Constants.myPageCornerRadius
        $0.backgroundColor = .SECONDARY01
    }
    
    private let pointTitleLabel = UILabel().then {
        $0.text = "내 원두 포인트"
        $0.font = .IM_Hyemin(.bold, size: 14.0)
        $0.textColor = .GRAY01
    }
    
    private let pointImageView = UIImageView(image: Constants.pointImage).then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let pointLabel = UILabel().then {
        $0.font = .BM_JUA(size: 16.0)
        $0.textColor = .BLACK_121212
    }
    
    private let makedDrinksButton = UIButton().then {
        $0.setTitle("내가 만든 음료", for: .normal)
        $0.setTitleColor(.GRAY01, for: .normal)
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 14.0)
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.secondaryBorder?.cgColor
        $0.layer.cornerRadius = Constants.myPageCornerRadius
        $0.backgroundColor = .myPageButtonBackgroud
    }
    
    private let sendedQuestionButton = UIButton().then {
        $0.setTitle("내가 보낸 질문", for: .normal)
        $0.setTitleColor(.GRAY01, for: .normal)
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 14.0)
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.secondaryBorder?.cgColor
        $0.layer.cornerRadius = Constants.myPageCornerRadius
        $0.backgroundColor = .myPageButtonBackgroud
    }
    
    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 10.0
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureUI() {
        
        [
            self.pointTitleLabel,
            self.pointImageView,
            self.pointLabel
        ].forEach {
            self.pointView.addSubview($0)
        }
        
        [
            self.pointView,
            self.buttonStackView
        ].forEach {
            self.contentView.addSubview($0)
        }
        
        [
            self.makedDrinksButton,
            self.sendedQuestionButton
        ].forEach {
            self.buttonStackView.addArrangedSubview($0)
        }
        
        self.contentView.backgroundColor = .p_ivory
        
        self.pointTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(28.0)
            make.centerY.equalToSuperview()
        }
        
        self.pointLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(26.0)
            make.centerY.equalTo(self.pointTitleLabel)
        }
        
        self.pointImageView.snp.makeConstraints { make in
            make.width.equalTo(14.53)
            make.height.equalTo(19.84)
            make.trailing.equalTo(self.pointLabel.snp.leading).offset(-7.0)
            make.centerY.equalToSuperview()
        }
        
        self.pointView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(64.0)
        }
        
        self.buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.pointView.snp.bottom).offset(11.0)
            make.height.equalTo(64.0)
            make.bottom.equalToSuperview()
        }
    }
    
    func update(with point: Int) {
        self.pointLabel.text = "\(point)P"
    }
}
