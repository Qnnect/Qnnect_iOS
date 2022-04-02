//
//  WatingQuestionViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/04/02.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class WaitingQuestionViewController: BaseViewController {
    
    
    private let contentTextView = UITextView().then {
        $0.isScrollEnabled = false
        $0.font = .IM_Hyemin(.bold, size: 14.0)
        $0.textColor = .BLACK_121212
        $0.backgroundColor = .cardBackground
        $0.textAlignment = .center
    }
    
    private let outerView = UIView().then {
        $0.backgroundColor = .cardBackground
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.secondaryBorder?.cgColor
        $0.layer.cornerRadius = 24.0
    }
    
    private var viewModel: WaitingQuestionViewModel!
    weak var coordinator: MyPageCoordinator?
    private var question: UserQuestion!
    
    static func create(
        with viewModel: WaitingQuestionViewModel,
        _ coordinator: MyPageCoordinator,
        _ question: UserQuestion
    ) -> WaitingQuestionViewController {
        let vc = WaitingQuestionViewController()
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Constants.navagation_more, style: .plain, target: self, action: #selector(self.didTapMoreButton))
    }
    
    override func bind() {
        super.bind()
        
        let input = WaitingQuestionViewModel.Input(
            question: Observable.just(question),
            didTapMoreButton: rx.methodInvoked(#selector(didTapMoreButton)).mapToVoid()
        )
        
        let output = viewModel.transform(from: input)
        

        guard let coordinator = coordinator else { return }

        output.showMoreMenu
            .emit(onNext: coordinator.showWaitingQuestionBottomSheet(_:))
            .disposed(by: self.disposeBag)
    }
    
}

extension WaitingQuestionViewController {
    @objc dynamic func didTapMoreButton() { }
}

