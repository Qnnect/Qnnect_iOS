//
//  AnswerQuestionCell.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/08.
//

import UIKit
import SnapKit
import Then


@objc
protocol QuestionCellButtonDelegate: AnyObject {
    dynamic func questionCellButton(didTap kind: String)
}

final class CafeAnswerQuestionCell: UITableViewCell {
    
    static let identifier = "CafeAnswerQuestionCell"
    
    // MARK: - Kind
    static let modify = "Modify"
    static let delete = "Delete"
    
    private let dateLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 10.0)
        $0.textColor = .GRAY02
    }
    
    private let questionerLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 12.0)
        $0.textColor = .BLACK_121212
    }
    
    private let daysLeftLabel = BasePaddingLabel(padding: UIEdgeInsets(top: 7.0, left: 9.0, bottom: 7.0, right: 9.0)).then {
        $0.font = .IM_Hyemin(.bold, size: 10.0)
        $0.textColor = .BLACK_121212
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.BLACK_121212?.cgColor
        $0.layer.cornerRadius = 12.0
    }
    
    private let contentLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 14.0)
        $0.textColor = .BLACK_121212
        $0.numberOfLines = 0
    }
    
    private let outerView = UIView().then {
        $0.layer.cornerRadius = 16.0
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.brownBorderColor?.cgColor
    }
    
    private let modifyButton = UIButton().then {
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 10.0)
        $0.setTitle("수정", for: .normal)
        $0.setTitleColor(.WHITE_FFFFFF, for: .normal)
    }
    
    private let deleteButton = UIButton().then {
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 10.0)
        $0.setTitle("삭제", for: .normal)
        $0.setTitleColor(.WHITE_FFFFFF, for: .normal)
    }
    
    weak var delegate: QuestionCellButtonDelegate?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
    
    private func configureUI() {
        
        [
            self.dateLabel,
            self.questionerLabel,
            self.daysLeftLabel,
            self.contentLabel,
            modifyButton,
            deleteButton
        ].forEach {
            self.outerView.addSubview($0)
        }
        
        self.contentView.addSubview(self.outerView)
        self.contentView.backgroundColor = .p_ivory
        
        self.outerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(14.0)
            make.leading.trailing.equalToSuperview().inset(20.0)
        }
        
        self.dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24.0)
            make.centerX.equalToSuperview()
        }
        
        self.questionerLabel.snp.makeConstraints { make in
            make.top.equalTo(self.dateLabel.snp.bottom).offset(1.0)
            make.centerX.equalToSuperview()
        }
        
        self.daysLeftLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16.0)
            make.trailing.equalToSuperview().inset(19.0)
        }
        
        self.contentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(1.2)
            make.leading.greaterThanOrEqualToSuperview().inset(8.0)
            make.top.greaterThanOrEqualTo(questionerLabel.snp.bottom).offset(8.0)
            make.trailing.bottom.lessThanOrEqualToSuperview().inset(8.0)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(3.0)
        }
        deleteButton.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)

        modifyButton.snp.makeConstraints { make in
            make.trailing.equalTo(deleteButton.snp.leading).inset(10.0)
            make.bottom.equalTo(deleteButton)
        }
        modifyButton.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
    }
    
    func update(with question: Question) {
        self.dateLabel.text = question.createdAt
        self.daysLeftLabel.text = "D-\(question.daysLeft)"
        self.questionerLabel.text = question.questioner == "넥트" ? "" : "\(question.questioner)의 질문"
        let paragraphStyle = Constants.paragraphStyle
        paragraphStyle.alignment = .center
        self.contentLabel.attributedText = NSAttributedString(
            string: question.content,
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
        self.outerView.backgroundColor = question.questioner == "넥트" ? .SECONDARY01 : .PINK01
        setQuestionButtons(question.writer)
    }
    
    private func setQuestionButtons(_ isWriter: Bool) {
        self.deleteButton.isHidden = !isWriter
        self.modifyButton.isHidden = !isWriter
    }
    
    @objc func didTapButton(sender: UIButton) {
        if sender == modifyButton {
            delegate?.questionCellButton(didTap: CafeAnswerQuestionCell.modify)
        } else {
            delegate?.questionCellButton(didTap: CafeAnswerQuestionCell.delete)
        }
    }
}
