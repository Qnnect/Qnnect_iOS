//
//  ModifyQuestionViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/16.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class ModifyQuestionViewController: BaseViewController {
    
    private let completionButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.isEnabled = false
        $0.setTitleColor(.ORANGE01, for: .normal)
    }
    
    private let contentTextView = UITextView().then {
        $0.isScrollEnabled = false
        $0.font = .IM_Hyemin(.bold, size: 14.0)
        $0.textColor = .BLACK_121212
        $0.backgroundColor = .ORANGE01
        $0.textAlignment = .center
    }
    
    private let outerView = UIView().then {
        $0.backgroundColor = .ORANGE01
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.secondaryBorder?.cgColor
        $0.layer.cornerRadius = 24.0
    }
    
    private let navigationTitleLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .GRAY01
        $0.text = "내 질문 수정"
    }
    
    private var viewModel: ModifyQuestionViewModel!
    weak var coordinator: QuestionCoordinator?
    private var question: Question!
    
    static func create(
        with viewModel: ModifyQuestionViewModel,
        _ coordinator: QuestionCoordinator,
        _ question: Question
    ) -> ModifyQuestionViewController {
        let vc = ModifyQuestionViewController()
        vc.viewModel = viewModel
        vc.coordinator = coordinator
        vc.question = question
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        
        outerView.addSubview(contentTextView)
        view.addSubview(outerView)
        
        outerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16.0)
            make.leading.trailing.equalToSuperview().inset(25.0)
            make.height.equalTo(255.0)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.top.greaterThanOrEqualToSuperview().inset(16.0)
            make.trailing.bottom.lessThanOrEqualToSuperview().inset(16.0)
        }
        contentTextView.text = question.content
        
        navigationItem.titleView = navigationTitleLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: completionButton)
    }
    
    override func bind() {
        super.bind()
        
        let input = ModifyQuestionViewModel.Input(
            question: Observable.just(question),
            didTapCompletionButton: completionButton.rx.tap.asObservable(),
            content: contentTextView.rx.text.orEmpty.asObservable()
        )
        
        let output = viewModel.transform(from: input)
        
        output.isCompleted
            .drive(onNext: setCompletionButton(_:))
            .disposed(by: self.disposeBag)
        
        guard let coordinator = coordinator else { return }

        output.completion
            .emit(onNext: coordinator.pop)
            .disposed(by: self.disposeBag)
        
    }
    
}

private extension ModifyQuestionViewController {
    func setCompletionButton(_ isCompleted: Bool) {
        if isCompleted {
            completionButton.setTitleColor(.ORANGE01, for: .normal)
            completionButton.isEnabled = true
        } else {
            completionButton.setTitleColor(.GRAY04, for: .normal)
            completionButton.isEnabled = false
        }
    }
}

