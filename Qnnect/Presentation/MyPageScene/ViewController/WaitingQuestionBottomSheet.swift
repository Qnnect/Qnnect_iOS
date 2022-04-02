//
//  WaitingQuestionBottomSheet.swift
//  Qnnect
//
//  Created by 재영신 on 2022/04/02.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class WaitingQuestionBottomSheet: BottomSheetViewController {
    
    private let modifyButton = MoreMenuItem(title: "질문 수정")
    private let deleteButton = MoreMenuItem(title: "질문 삭제")
    
    private let buttonStackView = UIStackView().then {
        $0.spacing = 30.0
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.alignment = .leading
    }
    
    private let deleteAlertView = DeleteAlertView().then {
        $0.modalPresentationStyle = .overCurrentContext
    }
    
    private var viewModel: WaitingQuestionBottomSheetViewModel!
    weak var coordinator: MyPageCoordinator?
    private var question: UserQuestion!
    
    static func create(
        with viewModel: WaitingQuestionBottomSheetViewModel,
        _ coordinator: MyPageCoordinator,
        _ question: UserQuestion
    ) -> WaitingQuestionBottomSheet {
        let view = WaitingQuestionBottomSheet()
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
        
        
        [
            modifyButton,
            deleteButton
        ].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        
        
        bottomSheetView.addSubview(buttonStackView)
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.top.equalToSuperview().inset(44.0)
        }
    }
    
    override func bind() {
        super.bind()
        
        let input = WaitingQuestionBottomSheetViewModel.Input(
            question: Observable.just(question),
            didTapModifyButton: modifyButton.rx.tap.asObservable(),
            didTapDeleteButton: deleteButton.rx.tap.asObservable(),
            didTapDeleteAlertOkButton: deleteAlertView.didTapOkButton
        )
        
        let output = viewModel.transform(from: input)
        
        output.showDeleteAlertView
            .emit(onNext: {
                [weak self] _ in
                guard let self = self else { return }
                self.present(self.deleteAlertView, animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
        
        guard let coordinator = coordinator else { return}
        
        output.delete
            .emit(onNext: {
                [weak self] _ in
                let naviVC = self?.presentingViewController as? UINavigationController
                self?.coordinator?.dismissMoreMenu({
                    naviVC?.popViewController(animated: true)
                    naviVC?.viewControllers.last?.view.makeToast("질문이 삭제 되었습니다.", duration: 3.0, position: .bottom)
                })
            })
            .disposed(by: self.disposeBag)
        
        output.showModifyQuestionScene
            .emit(onNext: coordinator.showModifyQuestionScene(_:))
            .disposed(by: self.disposeBag)
    }
}
