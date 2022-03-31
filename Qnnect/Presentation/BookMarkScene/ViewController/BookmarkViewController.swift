//
//  BookMarkViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/16.
//

import UIKit
import SnapKit
import Then
import TTGTags
import RxSwift

final class BookmarkViewController: BaseViewController {
    
    private let navigationTitleLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 18.0)
        $0.textColor = .BLACK_121212
        $0.text = "북마크"
    }
    
    private let headerView = UIView()
    
    private let tagCollectionView = BookmarkTagCollectionView()
    
    private let bookmarkTableView = UITableView(frame: .zero, style: .grouped).then {
        $0.register(BookmarkCell.self, forCellReuseIdentifier: BookmarkCell.identifier)
        $0.backgroundColor = .p_ivory
        $0.showsVerticalScrollIndicator = false
        $0.separatorInsetReference = .fromCellEdges
        $0.separatorInset = .init(top: 0, left: 23.0, bottom: 0, right: 23.0)
        $0.estimatedRowHeight = UITableView.automaticDimension
    }
    
    private let searchButton = UIButton().then {
        $0.setImage(Constants.navigation_search, for: .normal)
    }
    
    private let floatingButton = UIImageView().then {
        $0.image = Constants.floatingButtonImage
        $0.contentMode = .scaleAspectFit
    }
    
    private let floatingContainerView = UIView()
    
    
    private var viewModel: BookmarkViewModel!
    weak var coordinator: BookmarkCoordinator?
    
    static func create(
        with viewModel: BookmarkViewModel,
        _ coordinator: BookmarkCoordinator
    ) -> BookmarkViewController{
        let vc = BookmarkViewController()
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
        
        [
            bookmarkTableView,
            floatingContainerView
        ].forEach {
            view.addSubview($0)
        }
        
        floatingContainerView.addSubview(floatingButton)
        self.view.backgroundColor = .p_ivory
        
        self.navigationItem.leftBarButtonItems = [
            Constants.navigationLeftPadding,
            UIBarButtonItem(customView: self.navigationTitleLabel)
        ]
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: Constants.navigation_search,
            style: .plain,
            target: self,
            action: #selector(didTapSearchButton)
        )
        
        
        self.bookmarkTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.bookmarkTableView.sectionHeaderHeight = 60.0
        
        self.headerView.addSubview(self.tagCollectionView)
        
        self.tagCollectionView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview().inset(21.0)
            make.centerY.equalToSuperview()
        }
        
        
        floatingContainerView.snp.makeConstraints { make in
            make.width.equalTo(48.0)
            make.bottom.equalToSuperview()
            make.height.equalTo(150.0)
            make.trailing.equalToSuperview().inset(24.0)
        }
        
        floatingButton.snp.makeConstraints { make in
            make.width.height.equalTo(48.0)
            make.bottom.equalToSuperview()
        }
        
    }
    
    override func bind() {
        
        self.bookmarkTableView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        let input = BookmarkViewModel.Input(
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
            didTapQuestion: bookmarkTableView.rx.modelSelected(QuestionShortInfo.self)
                .map { $0.cafeQuestionId },
            didTapSearchButton: rx.methodInvoked(#selector(didTapSearchButton))
                .mapToVoid()
        )
        
        
        let output = self.viewModel.transform(from: input)
        
        floatingButton.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: {
                [weak self] _ in
                self?.bookmarkTableView.setContentOffset(.zero, animated: true)
            }).disposed(by: self.disposeBag)
        
        output.cafes
            .map { cafes -> [CafeTag] in
                let newCafes = [CafeTag(cafeId: 0, cafeTitle: "전체")] + cafes
                return newCafes
            }.drive(onNext: {
                [weak self] cafes in
                self?.tagCollectionView.update(with: cafes)
                self?.tagCollectionView.updateTag(at: 0, selected: true)
            }).disposed(by: self.disposeBag)
        
        output.scrapedQuestions
            .do {
                [weak self] questions in
                if questions.isEmpty {
                    self?.bookmarkTableView.setEmptyView(message: "아직 북마크한 질문이 없어요.")
                } else {
                    self?.bookmarkTableView.reset()
                }
            }
            .drive(self.bookmarkTableView.rx.items(cellIdentifier: BookmarkCell.identifier, cellType: BookmarkCell.self)) { index, model, cell in
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
        
        output.showSearchScene
            .emit(onNext: coordinator.showBookMarkSearchScene)
            .disposed(by: self.disposeBag)
    }
    
}

extension BookmarkViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.headerView
    }
    
    // section 의 separator 지우는 기능
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let border = CALayer()
        border.backgroundColor = tableView.backgroundColor?.cgColor
        border.frame = CGRect(x: 0, y: view.frame.size.height, width: view.frame.size.width, height: 1)
        view.layer.addSublayer(border)
    }
}

extension BookmarkViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == bookmarkTableView else { return }
        
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.size.height {
            if(isFetched){
                isFetched = false
                curPage += 1
                fetchMore(curPage)
            }
        }
        
        if scrollView.contentOffset.y > 50.0 {
            
            UIView.animate(
                withDuration: 0.5,
                delay: 0.1,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 0.5,
                options: [.curveEaseInOut]
            ) {
                [weak self] in
                guard let self = self else { return }
                self.floatingButton.snp.updateConstraints({ make in
                    make.bottom.equalToSuperview().inset(100.0)
                })
                self.floatingContainerView.layoutIfNeeded()
            }
        } else if scrollView.contentOffset.y <= 50.0 {
            UIView.animate(
                withDuration: 0.5,
                delay: 0.1,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 0.5,
                options: [.curveEaseInOut]
            ) {
                [weak self] in
                guard let self = self else { return }
                self.floatingButton.snp.updateConstraints({ make in
                    make.bottom.equalToSuperview()
                })
                self.floatingContainerView.layoutIfNeeded()
            }
        }
        
    }
    
    @objc dynamic func fetchMore(_ page: Int) {
        
    }
}

private extension BookmarkViewController {
    @objc dynamic func didTapSearchButton() {
    }
}
