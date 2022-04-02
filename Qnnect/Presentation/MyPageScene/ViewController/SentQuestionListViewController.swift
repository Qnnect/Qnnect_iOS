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
    
    private let mainTableView = UITableView(frame: .zero, style: .grouped).then {
        $0.backgroundColor = .p_ivory
        $0.register(BookmarkCell.self, forCellReuseIdentifier: BookmarkCell.identifier)
        $0.showsVerticalScrollIndicator = false
        $0.separatorInsetReference = .fromCellEdges
        $0.separatorInset = .init(top: 0, left: 23.0, bottom: 0, right: 23.0)
        $0.estimatedRowHeight = UITableView.automaticDimension
    }
    
    private let navigationTitleLabel = NavigationTitleLabel(title: "내가 보낸 질문")
    
    private let tagCollectionView = BookmarkTagCollectionView()
    private let headerView = UIView()
    
    private var viewModel: SentQuestionListViewModel!
    weak var coordinator: MyPageCoordinator?
    
    static func create(
        with viewModel: SentQuestionListViewModel,
        _ coordinator: MyPageCoordinator
    ) -> SentQuestionListViewController {
        let vc = SentQuestionListViewController()
        vc.viewModel = viewModel
        vc.coordinator = coordinator
        return vc
    }
    
    private var curPage = 0
    private var isFetched = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        
        view.addSubview(mainTableView)
        headerView.addSubview(tagCollectionView)
        
        mainTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        mainTableView.sectionHeaderHeight = 60.0
        mainTableView.delegate = self
        
        tagCollectionView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview().inset(21.0)
            make.centerY.equalToSuperview()
        }
        
        navigationItem.titleView = navigationTitleLabel
    }
    
    override func bind() {
        super.bind()
        
        let input = SentQuestionListViewModel.Input(
            viewDidLoad: Observable.just(()),
            viewWillAppear: rx.viewWillAppear.mapToVoid(),
            didTapCafeTag: self.tagCollectionView.rx.methodInvoked(#selector(self.tagCollectionView.textTagCollectionView(_:didTap:at:)))
                .map {
                    [weak self] param -> CafeTag in
                    let index = param[2] as! Int
                    return self?.tagCollectionView.cafes?[index] ?? CafeTag(cafeId: 0, cafeTitle: "전체")
                }.startWith(CafeTag(cafeId: 0, cafeTitle: "전체")),
            moreFetch: self.rx.methodInvoked(#selector(fetchMore))
                .map{ $0[0] as! Int},
            didTapQuestion: mainTableView.rx.modelSelected(UserQuestion.self).asObservable()
        )
        
        
        let output = self.viewModel.transform(from: input)
        
//        floatingButton.rx.tapGesture()
//            .when(.recognized)
//            .subscribe(onNext: {
//                [weak self] _ in
//                self?.bookmarkTableView.setContentOffset(.zero, animated: true)
//            }).disposed(by: self.disposeBag)
//
        output.cafes
            .map { cafes -> [CafeTag] in
                let newCafes = [CafeTag(cafeId: 0, cafeTitle: "전체")] + cafes
                return newCafes
            }.drive(onNext: {
                [weak self] cafes in
                self?.tagCollectionView.update(with: cafes)
                self?.tagCollectionView.updateTag(at: 0, selected: true)
            }).disposed(by: self.disposeBag)
        
        output.sentQuestions
            .do {
                [weak self] questions in
                if questions.isEmpty {
                    self?.mainTableView.setEmptyView(message: "아직 보낸 질문이 없어요.")
                } else {
                    self?.mainTableView.reset()
                }
            }
            .drive(mainTableView.rx.items(cellIdentifier: BookmarkCell.identifier, cellType: BookmarkCell.self)) { index, model, cell in
                cell.update(with: model)
            }.disposed(by: self.disposeBag)
        
        output.newLoad
            .debug()
            .emit(onNext: {
                [weak self] _ in
                self?.curPage = 0
            }).disposed(by: self.disposeBag)
        
        output.canLoad
            .emit(onNext: {
                [weak self] flag in
                if flag {
                    self?.isFetched = true
                }
            }).disposed(by: self.disposeBag)
        
        guard let coordinator = coordinator else { return }
        
        output.showCafeQuestionScene
            .emit(onNext: coordinator.showCafeQuestionScene(_:))
            .disposed(by: self.disposeBag)
        
        output.showWaitingQuestionScene
            .emit(onNext: coordinator.showWaitingQuestionScene(_:))
            .disposed(by: self.disposeBag)
    }
    
}

extension SentQuestionListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    // section 의 separator 지우는 기능
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let border = CALayer()
        border.backgroundColor = tableView.backgroundColor?.cgColor
        border.frame = CGRect(x: 0, y: view.frame.size.height, width: view.frame.size.width, height: 1)
        view.layer.addSublayer(border)
    }
}

extension SentQuestionListViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == mainTableView else { return }
        
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.size.height {
            if(isFetched){
                isFetched = false
                curPage += 1
                fetchMore(curPage)
            }
        }
        
//        if scrollView.contentOffset.y > 50.0 {
//
//            UIView.animate(
//                withDuration: 0.5,
//                delay: 0.1,
//                usingSpringWithDamping: 0.5,
//                initialSpringVelocity: 0.5,
//                options: [.curveEaseInOut]
//            ) {
//                [weak self] in
//                guard let self = self else { return }
//                self.floatingButton.snp.updateConstraints({ make in
//                    make.bottom.equalToSuperview().inset(100.0)
//                })
//                self.floatingContainerView.layoutIfNeeded()
//            }
//        } else if scrollView.contentOffset.y <= 50.0 {
//            UIView.animate(
//                withDuration: 0.5,
//                delay: 0.1,
//                usingSpringWithDamping: 0.5,
//                initialSpringVelocity: 0.5,
//                options: [.curveEaseInOut]
//            ) {
//                [weak self] in
//                guard let self = self else { return }
//                self.floatingButton.snp.updateConstraints({ make in
//                    make.bottom.equalToSuperview()
//                })
//                self.floatingContainerView.layoutIfNeeded()
//            }
//        }
        
    }
    
    @objc dynamic func fetchMore(_ page: Int) {
        
    }
}
