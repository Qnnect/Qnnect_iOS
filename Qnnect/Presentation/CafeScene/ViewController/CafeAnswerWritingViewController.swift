//
//  CafeAnswerWritingViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/08.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class CafeAnswerWritingViewController: BaseViewController {
    
    private let questionView = UIView().then {
        $0.layer.cornerRadius = 16.0
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.brownBorderColor?.cgColor
    }
    
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
    }
    
    private let writerProfileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 27.0 / 2.0
        $0.clipsToBounds = true
    }
    
    private let writerNameLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 14.0)
        $0.textColor = .BLACK_121212
    }
    
    private let inputTextView = UITextView().then {
        $0.isScrollEnabled = false
        $0.font = .IM_Hyemin(.bold, size: 14.0)
        $0.text = "답변을 입력하세요"
        $0.textColor = .GRAY04
        $0.sizeToFit()
        $0.backgroundColor = .p_ivory
        $0.autocorrectionType = .no
    }
    
    private let attachingImageButton = UIButton().then {
        $0.setImage(Constants.attachingImageIcon, for: .normal)
    }
    
    private lazy var bottomBar = UIToolbar().then {
        $0.setItems([UIBarButtonItem(customView: self.attachingImageButton),UIBarButtonItem.flexibleSpace()], animated: true)
        $0.barTintColor = .p_ivory
    }
    
    private let navigationCompletionButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.GRAY04, for: .normal)
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 16.0)
        $0.isEnabled = false
    }
    
    private var question: Question!
    private var user: User!
    private var viewModel: CafeAnswerWritingViewModel!
    
    static func create(
        with question: Question,
        _ user: User,
        _ viewModel: CafeAnswerWritingViewModel
    ) -> CafeAnswerWritingViewController {
        let vc = CafeAnswerWritingViewController()
        vc.question = question
        vc.user = user
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        
        [
            self.dateLabel,
            self.daysLeftLabel,
            self.questionerLabel,
            self.contentLabel
        ].forEach {
            self.questionView.addSubview($0)
        }
        
        [
            self.questionView,
            self.writerProfileImageView,
            self.writerNameLabel,
            self.inputTextView,
            self.bottomBar
        ].forEach {
            self.view.addSubview($0)
        }
        
        self.questionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(14.0)
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.height.equalTo(152.0)
        }
        self.questionView.backgroundColor = self.question.questioner == "넥트" ? .SECONDARY01 : .ORANGE01
        
        self.dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24.0)
            make.centerX.equalToSuperview()
        }
        self.dateLabel.text = self.question.createdAt
        
        self.questionerLabel.snp.makeConstraints { make in
            make.top.equalTo(self.dateLabel.snp.bottom).offset(1.0)
            make.centerX.equalToSuperview()
        }
        self.questionerLabel.text = "\(self.question.questioner)의 질문"
        
        self.daysLeftLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16.0)
            make.trailing.equalToSuperview().inset(19.0)
        }
        self.daysLeftLabel.text = "D-\(self.question.daysLeft)"
        
        self.contentLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.top.greaterThanOrEqualToSuperview().offset(8.0)
            make.trailing.bottom.lessThanOrEqualToSuperview().offset(8.0)
        }
        self.contentLabel.attributedText = NSAttributedString(
            string: self.question.question,
            attributes: [NSAttributedString.Key.paragraphStyle: Constants.paragraphStyle]
        )
        
        self.writerProfileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20.0)
            make.top.equalTo(self.questionView.snp.bottom).offset(30.0)
            make.width.height.equalTo(27.0)
        }
        
        self.writerProfileImageView.kf.setImage(
            with: URL(string: self.user.profileImage),
            placeholder: Constants.profileDefaultImage
        )
        
        self.writerNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.writerProfileImageView.snp.trailing).offset(8.0)
            make.centerY.equalTo(self.writerProfileImageView)
        }
        
        self.writerNameLabel.text = self.user.name
        
        self.inputTextView.snp.makeConstraints { make in
            make.top.equalTo(self.writerProfileImageView.snp.bottom).offset(8.0)
            make.leading.trailing.equalToSuperview().inset(20.0)
        }
        
        inputTextView.delegate = self
        
        self.bottomBar.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(50.0)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(bottomBarMoveUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(bottomBarMoveDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.navigationCompletionButton)
    }
    
    override func bind() {
        
        let input = CafeAnswerWritingViewModel.Input(
            inputText: self.inputTextView.rx.text.orEmpty
                .asObservable()
        )
        
        let output = self.viewModel.transform(from: input)
        
        output.isInputCompleted
            .drive(onNext: self.setCompletionButton(_:))
            .disposed(by: self.disposeBag)
    }
}

extension CafeAnswerWritingViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .GRAY04 {
            textView.text = nil
            textView.textColor = .BLACK_121212
        }
        
    }
    // TextView Place Holder
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "답변을 입력하세요"
            textView.textColor = .GRAY04
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let str = textView.text else { return true }
        let newLength = str.count + text.count - range.length
        return newLength <= 90
    }

}

private extension CafeAnswerWritingViewController {
    @objc func bottomBarMoveUp(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3, animations: {
                self.bottomBar.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height)
            }
            )
        }
    }
    @objc func bottomBarMoveDown(_ notification: NSNotification) {
        self.bottomBar.transform = .identity
    }
    
    func setCompletionButton(_ isCompleted: Bool) {
        if isCompleted {
            self.navigationCompletionButton.setTitleColor(.GRAY01, for: .normal)
            self.navigationCompletionButton.isEnabled = true
        } else {
            self.navigationCompletionButton.setTitleColor(.GRAY04, for: .normal)
            self.navigationCompletionButton.isEnabled = false
        }
    }
}
