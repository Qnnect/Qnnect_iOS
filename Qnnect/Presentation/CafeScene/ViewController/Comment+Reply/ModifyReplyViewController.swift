//
//  ModifyReplyViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/16.
//

import UIKit
import SnapKit
import Then

final class ModifyReplyViewController: BaseViewController {
    
    private let completionButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.isEnabled = false
        $0.setTitleColor(.GRAY04, for: .normal)
    }
    
    private let contentTextView = UITextView().then {
        $0.isScrollEnabled = false
        $0.font = .IM_Hyemin(.bold, size: 13.0)
        $0.textColor = .GRAY01
        $0.backgroundColor = .secondaryBackground
    }
    
    private let outerView = UIView().then {
        $0.backgroundColor = .secondaryBackground
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.reply_border?.cgColor
        $0.layer.cornerRadius = 16.0
    }
    
    private let navigationTitleLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .GRAY01
        $0.text = "댓글 수정"
    }
    
    private var viewModel: ModifyReplyViewModel!
    weak var coordinator: CommentCoordinator?
    private var commentId: Int!
    private var reply: Reply!
    
    static func create(
        with viewModel: ModifyReplyViewModel,
        _ coordinator: CommentCoordinator,
        _ reply: Reply,
        _ commentId: Int
    ) -> ModifyReplyViewController {
        let vc = ModifyReplyViewController()
        vc.viewModel = viewModel
        vc.coordinator = coordinator
        vc.commentId = commentId
        vc.reply = reply
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
            make.height.equalTo(136.0)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(14.0)
        }
        
        navigationItem.titleView = navigationTitleLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: completionButton)
        
        contentTextView.becomeFirstResponder()
    }
    
    override func bind() {
        super.bind()
    }
}
