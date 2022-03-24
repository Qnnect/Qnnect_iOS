//
//  MyCafeEmptyCell.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/20.
//

import UIKit
import SnapKit
import Then

@objc
protocol MyCafeEmptyCellButtonDelegate {
    func didTapEmptyCellAddCafeButton()
    func didTapEmptyCellJoinCafeButton()
}

final class MyCafeEmptyCell: UICollectionViewCell {
    
    static let identifier = "MyCafeEmptyCell"
    weak var delegate: MyCafeEmptyCellButtonDelegate?
    
    private let buttonBackimageView = UIImageView().then {
        $0.image = Constants.addCafeImage
        $0.contentMode = .scaleAspectFit
    }
    
    private(set) var addCafeButton = UIButton().then {
        $0.layer.borderWidth = 1.2
        $0.layer.borderColor = UIColor.brownBorderColor?.cgColor
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 12.0)
        $0.layer.cornerRadius = 18.0
        $0.setTitle("카페 만들기", for: .normal)
        $0.setTitleColor(.GRAY03, for: .normal)
        $0.backgroundColor = .p_ivory
    }
    
    private(set) var joinCafeButton = UIButton().then {
        $0.layer.borderWidth = 1.2
        $0.layer.borderColor = UIColor.brownBorderColor?.cgColor
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 12.0)
        $0.layer.cornerRadius = 18.0
        $0.setTitle("카페 참여하기", for: .normal)
        $0.setTitleColor(.GRAY03, for: .normal)
        $0.backgroundColor = .p_ivory
    }
    
    private let buttonStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.axis = .vertical
        $0.spacing = 12.0
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
        
        [
            addCafeButton,
            joinCafeButton
        ].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        [
            buttonBackimageView,
            buttonStackView
        ].forEach{
            contentView.addSubview($0)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(107.0)
            make.centerY.equalToSuperview()
            make.height.equalTo(84)
        }
       
        buttonBackimageView.snp.makeConstraints { make in
            make.leading.equalTo(buttonStackView).offset(34.0)
            make.trailing.equalTo(buttonStackView).offset(-34.0)
            make.top.equalToSuperview().offset(24.0)
            make.bottom.equalTo(addCafeButton.snp.centerY)
        }
        
        buttonBackimageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        addCafeButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        joinCafeButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        sender == addCafeButton ?
        delegate?.didTapEmptyCellAddCafeButton() :
        delegate?.didTapEmptyCellJoinCafeButton()
    }
}
