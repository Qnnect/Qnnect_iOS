//
//  ToDayQuestionCell.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/18.
//

import UIKit
import SnapKit
import Then

final class TodayQuestionCell: UICollectionViewCell {
    static let identifier = "TodayQuestionCell"
    
    private let groupNameLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 14.0)
        $0.textColor = .GRAY02
        $0.textAlignment = .center
    }
    
    private let d_dayLabel = BasePaddingLabel(padding: UIEdgeInsets(top: 7.0, left: 9.0, bottom: 7.0, right: 9.0)).then {
        $0.font = .IM_Hyemin(.bold, size: 10.0)
        $0.textColor = .BLACK_121212
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.BLACK_121212?.cgColor
        $0.layer.cornerRadius = 12.0
    }
    
    private let questionLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.numberOfLines = 0
        $0.textColor = .BLACK_121212
    }
    
    private(set) var emptyView = UIView().then {
        $0.backgroundColor = .SECONDARY01
        $0.layer.cornerRadius = Constants.homeCellCornerRadius
        $0.isHidden = true
    }
    
    private let emptyLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 12.0)
        $0.textColor = .GRAY03
        $0.text = "아직 질문이 없습니다."
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
            self.emptyView,
            self.groupNameLabel,
            self.d_dayLabel,
            self.questionLabel
        ].forEach {
            self.contentView.addSubview($0)
        }
        
        self.emptyView.addSubview(self.emptyLabel)
        
        self.contentView.backgroundColor = .SECONDARY01
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.brownBorderColor?.cgColor
        self.contentView.layer.cornerRadius = Constants.homeCellCornerRadius
        
        
        self.groupNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(26.0)
            make.leading.trailing.equalToSuperview().inset(12.0)
        }
        
        self.d_dayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15.0)
            make.trailing.equalToSuperview().inset(21.0)
        }
        
        self.questionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(31.0)
            make.center.equalToSuperview()
            make.bottom.equalToSuperview().inset(48.0)
        }
        
        self.emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.drawBottomShadow()
    }
    
    func update(with question: ToDayQuestion) {
        self.groupNameLabel.text = question.cafeTitle
        let paragraphStyle = Constants.paragraphStyle
        paragraphStyle.alignment = .center
        self.questionLabel.attributedText = NSAttributedString(
            string: question.content,
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
        self.d_dayLabel.text = "D-\(question.daysLeft)"
    }
    
    private func drawBottomShadow() {
        
        let path = UIBezierPath(
            roundedRect: CGRect(
                x: self.contentView.bounds.minX,
                y: self.contentView.bounds.minY,
                width: self.contentView.bounds.width,
                height: self.contentView.bounds.height + 4.0
            ),
            cornerRadius: Constants.homeCellCornerRadius
        )
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = path.lineWidth
        shapeLayer.strokeColor = self.layer.borderColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        self.contentView.layer.addSublayer(shapeLayer)
        
    }
}

