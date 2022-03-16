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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func configureUI() {
        
        self.view.addSubview(self.bookmarkTableView)
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
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(8.0)
        }
        self.bookmarkTableView.sectionHeaderHeight = 60.0
        
        self.headerView.addSubview(self.tagCollectionView)
        
        self.tagCollectionView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview().inset(21.0)
            make.centerY.equalToSuperview()
        }
        
    }
    
    override func bind() {
   
        self.bookmarkTableView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        let input = BookmarkViewModel.Input(
            viewDidLoad: Observable.just(()),
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

        output.showCafeAnswerScene
            .emit(onNext: coordinator.showCafeAnswerScene(_:))
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
    }
    
    @objc dynamic func fetchMore(_ page: Int) {
        
    }
}

private extension BookmarkViewController {
    @objc dynamic func didTapSearchButton() {
    }
}
