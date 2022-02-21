//
//  NameTextField.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/21.
//

import UIKit
import SnapKit
import Then

//MARK: TextField 크기 50 고정 View Height 지정 안해도 됨
final class NameTextField: UIView {
    
    private(set) var textField = UITextField().then {
        $0.layer.cornerRadius = 10.0
        $0.layer.borderWidth = 1
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20.0, height: $0.frame.height))
        $0.leftViewMode = .always
        $0.font = .IM_Hyemin(.regular, size: 14.0)
        $0.layer.borderColor = UIColor(red: 0.878, green: 0.878, blue: 0.878, alpha: 1).cgColor
    }
    
    private(set) var nameLengthLabel = UILabel().then {
        $0.text = "0/\(Constants.nameMaxLength)"
        $0.textColor = .GRAY04
        $0.font = .Roboto(.regular, size: 14.0)
    }
    
    private(set) var cautionLabel = UILabel().then {
        $0.text = Constants.nameInputCaution
        $0.textColor = .red
        $0.font = .IM_Hyemin(.regular, size: 14.0)
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
            self.textField,
            self.nameLengthLabel,
            self.cautionLabel
        ].forEach {
            self.addSubview($0)
        }
        
        self.textField.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(50.0)
        }
        
        self.nameLengthLabel.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.textField.snp.bottom).offset(4.0)
        }
        
        self.cautionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.textField.snp.bottom)
            make.leading.equalTo(self.textField).offset(8.0)
            make.height.equalTo(0)
        }
    }
    func setCautionLabel(_ isVaild: Bool) {
        if isVaild {
            self.cautionLabel.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
        } else {
            self.cautionLabel.snp.updateConstraints { make in
                make.height.equalTo(30.0)
            }
        }
    }
}
