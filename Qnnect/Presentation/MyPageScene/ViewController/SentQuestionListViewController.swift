//
//  SentQuestionListViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/23.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class SentQuestionListViewController: BaseViewController {
    
    private let mainTableView = UITableView().then {
        $0.backgroundColor = .p_ivory
        $0.setEmptyView(message: "준비중 입니다.")
        $0.register(BookmarkCell.self, forCellReuseIdentifier: BookmarkCell.identifier)
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
    
    override func bind() {
        super.bind()
        
        let data: [QuestionShortInfo] = [
            QuestionShortInfo(
                cafeQuestionId: -1,
                cafeTitle: "신사고 4인방",
                createdAt: "2022.3.21",
                content: "가족과 함께 가고싶은 외국여행지는 어디인가요?"
            ),
            QuestionShortInfo(
                cafeQuestionId: -1,
                cafeTitle: "아아메 4인방",
                createdAt: "2022.3.22",
                content: "서로가 가장 듣고싶은 칭찬은 무엇인가요?"
            ),
            QuestionShortInfo(
                cafeQuestionId: -1,
                cafeTitle: "우리 가족",
                createdAt: "2022.3.29",
                content: "우리 가족이 모두 ‘이거 하나는 지켜줬으면 좋겠다’ 하는것이 있나요?"
            )
        ]
        
        Observable.just(data)
            .do {
                [weak self] data in
                if data.isEmpty {
                    self?.mainTableView.setEmptyView(message: "질문이 없습니다.")
                } else {
                    self?.mainTableView.reset()
                }
            }
            .bind(to: mainTableView.rx.items(
                cellIdentifier: BookmarkCell.identifier,
                cellType: BookmarkCell.self
            )) { index, model, cell in
                cell.update(with: model)
            }.disposed(by: self.disposeBag)
    }
}


