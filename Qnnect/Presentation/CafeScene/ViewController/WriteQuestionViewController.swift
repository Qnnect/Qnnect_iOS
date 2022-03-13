//
//  QuestionWritingViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/13.
//

import UIKit
import SnapKit
import Then


final class WriteQuestionViewController: BaseViewController {
    
    private let completionButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.isEnabled = false
        $0.setTitleColor(.GRAY04, for: .normal)
    }
    
    private let mainLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .BLACK_121212
        $0.text = "내가 질문하기"
    }
    
    private let secondaryLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 12.0)
        $0.textColor = .GRAY03
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.23
        paragraphStyle.alignment = .left
        $0.attributedText = NSAttributedString(
            string: "직접 묻고 싶은 질문이 있나요?\n친구들에게 질문해보세요,\n다음 질문으로 바로 전달됩니다",
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
        $0.numberOfLines = 3
    }
    
    private let cardView = UIView().then {
        $0.layer.cornerRadius = 24.0
        $0.backgroundColor = .cardBackground
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.secondaryBorder?.cgColor
    }
    
    private let cardBackgroundView = UIView().then {
        $0.layer.cornerRadius = 24.0
        $0.backgroundColor = .cardBackground
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.secondaryBorder?.cgColor
    }
    
    /// 질문 10~50글자 이내
    private let inputTextView = UITextView().then {
        $0.isScrollEnabled = false
        $0.sizeToFit()
        $0.textAlignment = .center
        $0.font = .IM_Hyemin(.bold, size: 14.0)
        $0.text = "질문을 입력하세요"
        $0.textColor = .GRAY03
        $0.backgroundColor = .cardBackground
    }
    
    static func create() -> WriteQuestionViewController {
        let vc = WriteQuestionViewController()
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        
        [
            mainLabel,
            secondaryLabel,
            cardBackgroundView,
            cardView
        ].forEach {
            view.addSubview($0)
        }
            
        mainLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20.0)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(23.0)
        }
        
        secondaryLabel.snp.makeConstraints { make in
            make.leading.equalTo(mainLabel)
            make.top.equalTo(mainLabel.snp.bottom).offset(10.0)
        }
        
        cardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(25.0)
            make.top.equalTo(secondaryLabel.snp.bottom).offset(41.0)
            make.height.equalTo(256.0)
        }
        cardView.addSubview(inputTextView)
        
        cardBackgroundView.snp.makeConstraints { make in
            make.edges.equalTo(cardView)
        }
        cardBackgroundView.transform = .init(rotationAngle: CGFloat.pi + 0.1)
        
        inputTextView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.top.greaterThanOrEqualToSuperview().inset(8.0)
            make.trailing.bottom.lessThanOrEqualToSuperview().inset(8.0)
        }
        inputTextView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: completionButton)
    }
    
    override func bind() {
        super.bind()
    }
}


extension WriteQuestionViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .GRAY03 {
            textView.text = nil
            textView.textColor = .BLACK_121212
        }
        
    }
    // TextView Place Holder
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "질문을 입력하세요"
            textView.textColor = .GRAY03
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let str = textView.text else { return true }
        let newLength = str.count + text.count - range.length
        return newLength <= 50
    }

}
