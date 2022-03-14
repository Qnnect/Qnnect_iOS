//
//  CommentViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/14.
//

import UIKit
import SnapKit
import Then

final class CommentViewController: BaseViewController {
    
    private var viewModel: CommentViewModel!
    private var commentId: Int!
    
    static func create(
        with viewModel: CommentViewModel,
        _ commentId: Int
    ) -> CommentViewController {
        let vc = CommentViewController()
        vc.viewModel = viewModel
        vc.commentId = commentId
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
    }
    
    override func bind() {
        super.bind()
    }
}
