//
//  ReplyMoreMenuBottomSheet.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/16.
//

import UIKit
import SnapKit
import Then
import RxSwift

class ReplyMoreMenuBottomSheet: BottomSheetViewController {
    
    private let modifyButton = UIButton().then {
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 16.0)
        $0.setTitleColor(.GRAY01, for: .normal)
        $0.setTitle("댓글 수정", for: .normal)
        $0.sizeToFit()
    }
    
    private let deleteButton = UIButton().then {
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 16.0)
        $0.setTitleColor(.GRAY01, for: .normal)
        $0.setTitle("댓글 삭제", for: .normal)
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
    
    private var viewModel: ReplyMoreMenuViewModel!
    weak var coordinator: CommentCoordinator?
    private var replyId: Int!
    private var commentId: Int!
    
    static func create(
        with viewModel: ReplyMoreMenuViewModel,
        _ coordinator: CommentCoordinator,
        replyId: Int,
        commentId: Int
    ) -> ReplyMoreMenuBottomSheet {
        let view = ReplyMoreMenuBottomSheet()
        view.viewModel = viewModel
        view.coordinator = coordinator
        view.replyId = replyId
        view.commentId = commentId
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
        
        let input = ReplyMoreMenuViewModel.Input(
            replyId: Observable.just(replyId),
            commentId: Observable.just(commentId),
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
            .emit(onNext: coordinator.dismissReplyMoreMenu)
            .disposed(by: self.disposeBag)
        
        output.modify
            .emit()
            .disposed(by: self.disposeBag)
    }
}
