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
            self.groupNameLabel,
            self.d_dayLabel,
            self.questionLabel
        ].forEach {
            self.contentView.addSubview($0)
        }
        
        self.contentView.backgroundColor = .SECONDARY01
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.brownBorderColor?.cgColor
        self.contentView.layer.cornerRadius = Constants.HomeCellCornerRadius
        
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
    }
    
    func update(with question: Question) {
        self.groupNameLabel.text = question.groupName
        self.questionLabel.text = question.content
        self.d_dayLabel.text = question.d_day
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
@available(iOS 13.0, *)
struct presentable: UIViewRepresentable {
    func updateUIView(_ uiView: UIViewType, context: Context) { }
    func makeUIView(context: Context) -> some UIView {
        let a = TodayQuestionCell()
        a.update(with: Question(groupName: "INFP5인방", d_day: "D-7", content: "Dsfadsfasdfsdafasdfdasfsdakjfsdikfjasdfjsdffsdak;fjasdklfjasdklsd"))
        return a
    }
}

@available(iOS 13.0, *)
struct TodayQuestionCell_Priview: PreviewProvider {
    static var previews: some View {
        presentable()
            .previewLayout(.fixed(width: 333.0, height: 200.0))
    }
}
#endif
