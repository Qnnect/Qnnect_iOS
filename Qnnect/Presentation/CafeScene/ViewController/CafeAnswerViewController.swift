//
//  CafeAnswerViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/08.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxDataSources

final class CafeAnswerViewController: BaseViewController {
    
    private let mainTableView = UITableView().then {
        $0.backgroundColor = .p_ivory
        $0.separatorStyle = .none
        $0.register(
            CafeAnswerQuestionCell.self,
            forCellReuseIdentifier: CafeAnswerQuestionCell.identifier
        )
        $0.register(
            CafeAnswerWritingCell.self,
            forCellReuseIdentifier: CafeAnswerWritingCell.identifier
        )
    }
    
    private let likeButton = UIButton().then {
        $0.setImage(Constants.navigationHeartIcon, for: .normal)
    }
    
    private let scrapButton = UIButton().then {
        $0.setImage(Constants.navigationScrapIcon, for: .normal)
    }
    
    private var question: Question!
    private var user: User!
    private var viewModel: CafeAnswerViewModel!
    
    static func create(
        with viewModel: CafeAnswerViewModel,
        _ question: Question,
        _ user: User
    ) -> CafeAnswerViewController {
        let vc = CafeAnswerViewController()
        vc.viewModel = viewModel
        vc.question = question
        vc.user = user
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func configureUI() {
        
        self.view.addSubview(self.mainTableView)
        
        self.mainTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: self.scrapButton),
            UIBarButtonItem(customView: self.likeButton)
        ]
    }
    
    override func bind() {
        Observable.zip(Observable.just(self.question),Observable.just(self.user))
            .map { question,user -> [CafeAnswerSectionModel] in
                let questionSectionItem = CafeAnswerSectionItem.questionSectionItem(question: question!)
                let answerWritingSectionItem = CafeAnswerSectionItem.answerWritingSectionItem(user: user!)
                return [
                    CafeAnswerSectionModel.questionSection(title: "", items: [questionSectionItem]),
                    CafeAnswerSectionModel.answerWritingSection(title: "", items: [answerWritingSectionItem])
                ]
            }.bind(to: self.mainTableView.rx.items(dataSource: self.createDataSource()))
            .disposed(by: self.disposeBag)
        
        self.mainTableView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        let input = CafeAnswerViewModel.Input(
            didTapAnswerWritingCell: self.mainTableView.rx.itemSelected
                .map { $0.section == 1 }
                .mapToVoid(),
            question: Observable.just(question),
            user: Observable.just(user),
            didTapScrapButton: self.scrapButton.rx.tap.scan(
                false,
                accumulator: { lastState, newValue in !lastState }
            ).do {
                print("scrap",$0)
            }
        )
        
        let output = self.viewModel.transform(from: input)
        
        output.showAnswerWritingScene
            .emit()
            .disposed(by: self.disposeBag)
        
        output.scrap
            .emit(onNext: {
                [weak self] _ in
                self?.scrapButton.setImage(Constants.navigationCheckedScrapIcon, for: .normal)
            })
            .disposed(by: self.disposeBag)
        
        output.cancleScrap
            .emit(onNext: {
                [weak self] _ in
                self?.scrapButton.setImage(Constants.navigationScrapIcon, for: .normal)
            })
            .disposed(by: self.disposeBag)
    }
}

extension CafeAnswerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 180.0
        }
        return 130.0
    }
    
    
}

private extension CafeAnswerViewController {
    func createDataSource() -> RxTableViewSectionedAnimatedDataSource<CafeAnswerSectionModel> {
        return RxTableViewSectionedAnimatedDataSource<CafeAnswerSectionModel> {
            datasource, tableView, indexPath, item in
            
            switch item {
            case .questionSectionItem(question: let question):
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: CafeAnswerQuestionCell.identifier,
                    for: indexPath
                ) as! CafeAnswerQuestionCell
                cell.update(with: question)
                return cell
            case .answerWritingSectionItem(user: let user):
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: CafeAnswerWritingCell.identifier,
                    for: indexPath
                ) as! CafeAnswerWritingCell
                cell.update(with: user)
                return cell
            }
        }
    }
}
