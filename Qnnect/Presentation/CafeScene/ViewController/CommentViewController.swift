//
//  CommentViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/14.
//

import UIKit
import SnapKit
import Then
import RxSwift

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
        
        let input = CommentViewModel.Input(
            viewDidLoad: Observable.just(()),
            commentId: Observable.just(commentId)
        )
        
        let output = viewModel.transform(from: input)
        
        output.comment
            .drive(onNext: {
                print("comment",$0)
            }).disposed(by: self.disposeBag)
        
        output.replies
            .drive(onNext: {
                print("replies",$0)
            }).disposed(by: self.disposeBag)
    }
}
