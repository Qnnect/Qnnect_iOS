//
//  SentQuestionListViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/23.
//

import UIKit
import SnapKit
import Then

final class SentQuestionListViewController: BaseViewController {
    
    private let mainTableView = UITableView().then {
        $0.backgroundColor = .p_ivory
        $0.setEmptyView(message: "준비중 입니다.")
    }
    
    private let navigationTitleLabel = NavigationTitleLabel(title: "내가 보낸 질문")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    static func create() -> SentQuestionListViewController {
        let vc = SentQuestionListViewController()
        return vc
    }
    
    override func configureUI() {
        super.configureUI()
        
        view.addSubview(mainTableView)
        
        mainTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        navigationItem.titleView = navigationTitleLabel
    }
}
