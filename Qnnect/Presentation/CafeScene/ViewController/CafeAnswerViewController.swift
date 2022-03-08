//
//  CafeAnswerViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/08.
//

import UIKit
import SnapKit
import Then

final class CafeAnswerViewController: BaseViewController {
    
    private let mainTableView = UITableView().then {
        $0.backgroundColor = .p_ivory
    }
    
    private var question: Question!
    private var viewModel: CafeAnswerViewModel!
    
    static func create(
        with viewModel: CafeAnswerViewModel,
        _ question: Question
    ) -> CafeAnswerViewController {
        let vc = CafeAnswerViewController()
        vc.viewModel = viewModel
        vc.question = question
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        
    }
    
    override func bind() {
        
    }
}
