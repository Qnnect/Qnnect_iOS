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

final class CafeQuestionViewController: BaseViewController {
    
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
    
    private let moreMenuButton = UIButton().then {
        $0.setImage(Constants.navagation_more, for: .normal)
    }
    
    private let deleteAlertView = DeleteAlertView().then {
        $0.modalPresentationStyle = .overCurrentContext
    }
    
    private var questionId: Int!
    private var viewModel: CafeQuestionViewModel!
    weak var coordinator: QuestionCoordinator?
    
    static func create(
        with viewModel: CafeQuestionViewModel,
        _ questionId: Int,
        _ coordinator: QuestionCoordinator
    ) -> CafeQuestionViewController {
        let vc = CafeQuestionViewController()
        vc.viewModel = viewModel
        vc.questionId = questionId
        vc.coordinator = coordinator
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
            UIBarButtonItem(customView: moreMenuButton),
            UIBarButtonItem.fixedSpace(15.0),
            UIBarButtonItem(customView: self.scrapButton),
            UIBarButtonItem.fixedSpace(15.0),
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
        
        let input = CafeQuestionViewModel.Input(
            didTapAnswerWritingCell: self.mainTableView.rx.modelSelected(CafeAnswerSectionItem.self)
                .filter {
                    if case CafeAnswerSectionItem.answerWritingSectionItem(_) = $0 {
                    return true
                }
                    return false
                }
                .mapToVoid(),
            didTapScrapButton: self.scrapButton.rx.tap.asObservable()
                .withLatestFrom(scrapButton.imageView!.rx.image.map { $0 == Constants.navigationScrapIcon }),
            questionId: Observable.just(questionId),
            viewWillAppear: rx.viewWillAppear.mapToVoid(),
            didTapAnswerCell: mainTableView.rx.modelSelected(CafeAnswerSectionItem.self)
                .compactMap { item -> Comment? in
                    guard case let CafeAnswerSectionItem.answerSectionItem(comment) = item else { return nil }
                    return comment
                },
            didTapLikeButton: likeButton.rx.tap.asObservable()
                .withLatestFrom(likeButton.imageView!.rx.image.map{ $0 != Constants.navigationHeartIcon} )
                .do {
                    [weak self] in
                    self?.setLikeButton(!$0)
                },
            didTapMoreMenuButton: moreMenuButton.rx.tap.asObservable()
        )
        
        
        let output = self.viewModel.transform(from: input)
        
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
        
        Observable.zip(
            output.question.asObservable(),
            output.user.asObservable(),
            output.comments.asObservable(),
            output.currentUserComment.asObservable()
        )
            .map { question, user, comments, currentUserComment -> [CafeAnswerSectionModel] in
                var models = [CafeAnswerSectionModel]()
                let questionSectionItem = CafeAnswerSectionItem.questionSectionItem(question: question)
                models.append( CafeAnswerSectionModel.questionSection(title: "", items: [questionSectionItem]))
                if currentUserComment == nil {
                    let answerWritingSectionItem = CafeAnswerSectionItem.answerWritingSectionItem(user: user)
                    models.append(CafeAnswerSectionModel.answerWritingSection(title: "", items: [answerWritingSectionItem]))
                    let answerSectionItems = comments.map {CafeAnswerSectionItem.answerSectionItem(comment: $0)}
                    models.append(CafeAnswerSectionModel.answerSection(title: "", items: answerSectionItems))
                } else {
                    let newComments = [currentUserComment!] + comments
                    let answerSectionItem = newComments.map { CafeAnswerSectionItem.answerSectionItem(comment: $0)}
                    models.append(CafeAnswerSectionModel.answerSection(title: "", items: answerSectionItem))
                }
                
                return models
            }.bind(to: self.mainTableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        output.liked
            .drive(onNext: {
                [weak self] in
                $0 ? self?.likeButton.setImage(Constants.navigationCheckedHeartIcon, for: .normal) :
                self?.likeButton.setImage(Constants.navigationHeartIcon, for: .normal)
            }).disposed(by: self.disposeBag)
        
        output.like
            .emit()
            .disposed(by: self.disposeBag)
        
        
        guard let coordinator = coordinator else { return }
        
        output.showWriteCommentScene
            .emit(onNext: coordinator.showWriteCommentScene)
            .disposed(by: self.disposeBag)
        
        output.showCommentScene
            .emit(onNext: coordinator.showCommentScene)
            .disposed(by: self.disposeBag)
        
        output.showMoreMenu
            .emit(onNext: coordinator.showMoreMenu(_:))
            .disposed(by: self.disposeBag)
    
    }
}

extension CafeQuestionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 180.0
        }
        return Constants.answerCellHeight + Constants.answerCellSpacing
    }
}

private extension CafeQuestionViewController {
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
    
    /// 좋아요 버튼 설정
    /// - Parameter isLiked: 현재 좋아요 상태
    func setLikeButton(_ isLiked: Bool) {
        isLiked ? likeButton.setImage(Constants.navigationCheckedHeartIcon, for: .normal) :
        likeButton.setImage(Constants.navigationHeartIcon, for: .normal)
    }
    
    func setScrapButton(_ isScraped: Bool) {
        isScraped ? scrapButton.setImage(Constants.navigationScrapIcon, for: .normal) :
        scrapButton.setImage(Constants.navigationScrapIcon, for: .normal)
    }
}
