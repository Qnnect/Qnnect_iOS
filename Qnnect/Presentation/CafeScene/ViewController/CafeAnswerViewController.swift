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
        $0.register(
            CafeAnswerCell.self,
            forCellReuseIdentifier: CafeAnswerCell.identifier
        )
    }
    
    private let likeButton = UIButton().then {
        $0.setImage(Constants.navigationHeartIcon, for: .normal)
    }
    
    private let scrapButton = UIButton().then {
        $0.setImage(Constants.navigationScrapIcon, for: .normal)
    }
    
    private var questionId: Int!
    private var viewModel: CafeAnswerViewModel!
    
    static func create(
        with viewModel: CafeAnswerViewModel,
        _ questionId: Int
    ) -> CafeAnswerViewController {
        let vc = CafeAnswerViewController()
        vc.viewModel = viewModel
        vc.questionId = questionId
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
        
        self.mainTableView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        let dataSource = self.createDataSource()
        
        dataSource.animationConfiguration = .init(
            insertAnimation: .left,
            reloadAnimation: .none,
            deleteAnimation: .automatic
        )
        
        dataSource.decideViewTransition = { (_, _, _)  in return RxDataSources.ViewTransition.reload }
        
        let input = CafeAnswerViewModel.Input(
            didTapAnswerWritingCell: self.mainTableView.rx.itemSelected
                .filter { $0.section == 1 }
                .mapToVoid(),
            didTapScrapButton: self.scrapButton.rx.tap.scan(
                false,
                accumulator: { lastState, newValue in !lastState }
            ).do {
                print("scrap",$0)
            },
            questionId: Observable.just(questionId),
            viewWillAppear: rx.viewWillAppear.mapToVoid(),
            didTapAnswerCell: mainTableView.rx.modelSelected(CafeAnswerSectionItem.self)
                .compactMap { item -> Comment? in
                    guard case let CafeAnswerSectionItem.answerSectionItem(comment) = item else { return nil }
                    return comment
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
        
        output.showCommentScene
            .emit()
            .disposed(by: self.disposeBag)
        
        Observable.combineLatest(
            output.question.asObservable(),
            output.user.asObservable(),
            output.comments.asObservable()
        )
            .map { question, user, comments -> [CafeAnswerSectionModel] in
                let questionSectionItem = CafeAnswerSectionItem.questionSectionItem(question: question)
                let answerWritingSectionItem = CafeAnswerSectionItem.answerWritingSectionItem(user: user)
                let answerSectionItem = comments.map {CafeAnswerSectionItem.answerSectionItem(comment: $0)}
                return [
                    CafeAnswerSectionModel.questionSection(title: "", items: [questionSectionItem]),
                    CafeAnswerSectionModel.answerWritingSection(title: "", items: [answerWritingSectionItem]),
                    CafeAnswerSectionModel.answerSection(title: "", items: answerSectionItem)
                ]
            }.bind(to: self.mainTableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)

    }
}

extension CafeAnswerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 180.0
        }
        return Constants.answerCellHeight + Constants.answerCellSpacing
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
            case .answerSectionItem(comment: let comment):
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: CafeAnswerCell.identifier,
                    for: indexPath
                ) as! CafeAnswerCell
                cell.update(with: comment)
                return cell
            }
        }
    }
}
