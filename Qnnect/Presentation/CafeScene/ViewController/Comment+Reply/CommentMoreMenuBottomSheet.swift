//
//  MoreMenuBottomSheet.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/16.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class CommentMoreMenuBottomSheet: BottomSheetViewController {
    
    private let modifyButton = MoreMenuItem(title: "답변 수정")
    
    private let deleteButton = MoreMenuItem(title: "답변 삭제")
    private let reportButton = MoreMenuItem(title: "신고 하기")
    private let buttonStackView = UIStackView().then {
        $0.spacing = 30.0
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.alignment = .leading
    }
    
    private let deleteAlertView = DeleteAlertView().then {
        $0.modalPresentationStyle = .overCurrentContext
    }
    
    private var comment: Comment!
    private var question: Question!
    private var viewModel: CommentMoreMenuViewModel!
    weak var coordinator: CommentCoordinator?
    
    static func create(
        with comment: Comment,
        _ viewModel: CommentMoreMenuViewModel,
        _ coordinator: CommentCoordinator,
        _ question : Question
    ) -> CommentMoreMenuBottomSheet {
        let view = CommentMoreMenuBottomSheet()
        view.comment = comment
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
        
        let input = CommentMoreMenuViewModel.Input(
            comment: Observable.just(comment),
            question: Observable.just(question),
            didTapDeleteButton: deleteButton.rx.tap.asObservable(),
            didTapModifyButton: modifyButton.rx.tap.asObservable(),
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
            .map { CommentMoreMenuItem.delete }
            .emit(onNext: coordinator.dismissCommentMoreMenu)
            .disposed(by: self.disposeBag)
        
        output.modify
            .emit()
            .disposed(by: self.disposeBag)
        
        output.showWriteCommentScene
            .emit(onNext: coordinator.showWriteCommentScene)
            .disposed(by: self.disposeBag)
        
    }
}
