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
    
    private let modifyButton = UIButton().then {
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 16.0)
        $0.setTitleColor(.GRAY01, for: .normal)
        $0.setTitle("답변 수정", for: .normal)
        $0.sizeToFit()
    }
    
    private let deleteButton = UIButton().then {
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 16.0)
        $0.setTitleColor(.GRAY01, for: .normal)
        $0.setTitle("답변 삭제", for: .normal)
        $0.sizeToFit()
    }
    
    private let buttonStackView = UIStackView().then {
        $0.spacing = 30.0
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.alignment = .leading
    }
    
    private let deleteAlertView = DeleteAlertView().then {
        $0.modalPresentationStyle = .overCurrentContext
    }
    
    private var commentId: Int!
    private var viewModel: CommentMoreMenuViewModel!
    weak var coordinator: CommentCoordinator?
    
    static func create(
        with commentId: Int,
        _ viewModel: CommentMoreMenuViewModel,
        _ coordinator: CommentCoordinator
    ) -> CommentMoreMenuBottomSheet {
        let view = CommentMoreMenuBottomSheet()
        view.commentId = commentId
        view.viewModel = viewModel
        view.coordinator = coordinator
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        
        topPadding = 653.0
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
            make.top.bottom.equalToSuperview().inset(44.0)
        }
    }
    
    override func bind() {
        super.bind()
        
        let input = CommentMoreMenuViewModel.Input(
            commentId: Observable.just(commentId),
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
            .emit(onNext: coordinator.dismissCommentMoreMenu)
            .disposed(by: self.disposeBag)
        
        output.modify
            .emit()
            .disposed(by: self.disposeBag)
        
    }
}
