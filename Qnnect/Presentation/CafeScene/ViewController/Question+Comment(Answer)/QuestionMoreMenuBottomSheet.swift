//
//  QuestionMoreMenuBottomSheet.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/22.
//
import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa


class QuestionMoreMenuBottomSheet : BottomSheetViewController {
    
    
    private let buttonStackView = UIStackView().then {
        $0.spacing = 30.0
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.alignment = .leading
    }
    
    private lazy var modifyButton = MoreMenuItem(title: "질문 수정")
    private lazy var deleteButton = MoreMenuItem(title: "질문 삭제")
    private lazy var reportButton = MoreMenuItem(title: "신고 하기")
    private lazy var deleteAlertView = DeleteAlertView()
    
    private var viewModel: QuestionMoreMenuViewModel!
    weak var coordinator: QuestionCoordinator?
    private var question: Question!
    
    static func create(
        with viewModel: QuestionMoreMenuViewModel,
        _ coordinator: QuestionCoordinator,
        _ question: Question
    ) -> QuestionMoreMenuBottomSheet {
        let view = QuestionMoreMenuBottomSheet()
        view.viewModel = viewModel
        view.coordinator = coordinator
        view.question = question
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        
        topPadding = UIScreen.main.bounds.height * 0.75
        
        dismissButton.isHidden = true
        if question.writer {
            buttonStackView.addArrangedSubview(modifyButton)
            buttonStackView.addArrangedSubview(deleteButton)
        } else {
            buttonStackView.addArrangedSubview(reportButton)
        }
        
        bottomSheetView.addSubview(buttonStackView)
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.top.equalToSuperview().inset(44.0)
        }
    }
    
    override func bind() {
        super.bind()
        
        let input = QuestionMoreMenuViewModel.Input(
            question: Observable.just(question),
            didTapModifyButton: modifyButton.rx.tap.asObservable(),
            didTapDeleteButton: deleteButton.rx.tap.asObservable(),
            didTapDeleteAlertOkButton: deleteAlertView.didTapOkButton
        )
        
        let output = viewModel.transform(from: input)
        
        guard let coordinator = coordinator else { return }
        
        output.showModeifyQuestionScene
            .emit(onNext: coordinator.showModifyQuestionScene(_:))
            .disposed(by: self.disposeBag)
        
        output.showDeleteAlertView
            .emit(onNext: {
                [weak self] _ in
                guard let self = self else { return }
                self.present(self.deleteAlertView, animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
        
        output.delete
            .emit(onNext: coordinator.pop)
            .disposed(by: self.disposeBag)
        
    }
}
