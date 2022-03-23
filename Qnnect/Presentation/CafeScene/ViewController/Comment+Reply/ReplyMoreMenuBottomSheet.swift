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
    
    private let modifyButton = MoreMenuItem(title: "댓글 수정")
    private let deleteButton = MoreMenuItem(title: "댓글 삭제")
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
    
    private var viewModel: ReplyMoreMenuViewModel!
    weak var coordinator: CommentCoordinator?
    private var reply: Reply!
    private var commentId: Int!
    
    static func create(
        with viewModel: ReplyMoreMenuViewModel,
        _ coordinator: CommentCoordinator,
        _ reply: Reply,
        _ commentId: Int
    ) -> ReplyMoreMenuBottomSheet {
        let view = ReplyMoreMenuBottomSheet()
        view.viewModel = viewModel
        view.coordinator = coordinator
        view.reply = reply
        view.commentId = commentId
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
        
        let input = ReplyMoreMenuViewModel.Input(
            reply: Observable.just(reply),
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
        
        
        output.showModifyReplyScene
            .emit(onNext: coordinator.showModifyReplyScene)
            .disposed(by: self.disposeBag)
    }
}
