//
//  SearchCafeQuestionViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/16.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class SearchCafeQuestionViewController: BaseViewController {
    
    private let questionListTableView = UITableView().then {
        $0.register(CafeQuestionListCell.self, forCellReuseIdentifier: CafeQuestionListCell.identifier)
        $0.backgroundColor = .p_ivory
        $0.showsVerticalScrollIndicator = false
        $0.separatorInsetReference = .fromCellEdges
        $0.separatorInset = .init(top: 0, left: 23.0, bottom: 0, right: 23.0)
        $0.estimatedRowHeight = UITableView.automaticDimension
    }
    
    private let searchBar = UISearchBar().then {
        $0.placeholder = "질문리스트에서 검색"
        $0.searchTextField.font = .IM_Hyemin(.bold, size: 14.0)
    }
    
    private var viewModel: SearchCafeQuestionViewModel!
    weak var coordinator: CafeCoordinator?
    private var cafeId: Int!
    
    static func create(
        with viewModel: SearchCafeQuestionViewModel,
        _ coordinator: CafeCoordinator,
        _ cafeId: Int
    ) -> SearchCafeQuestionViewController {
        let vc = SearchCafeQuestionViewController()
        vc.viewModel = viewModel
        vc.coordinator = coordinator
        vc.cafeId = cafeId
        return vc
    }
    
    private var curPage = 0
    private var isFetched = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        
        view.addSubview(questionListTableView)
        
        questionListTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        questionListTableView.delegate = self
        
        navigationItem.titleView = searchBar
    }
    
    override func bind() {
        super.bind()
        
        let input = SearchCafeQuestionViewModel.Input(
            cafeId: Observable.just(cafeId),
            searchWord: searchBar.rx.text.orEmpty
                .filter { $0.count > 0 }
                .do {
                    [weak self] _ in
                    self?.curPage = 0
                }
                .asObservable(),
            moreFetch: self.rx.methodInvoked(#selector(fetchMore))
                .map{ $0[0] as! Int},
            didTapQuestionCell: questionListTableView.rx.modelSelected(QuestionShortInfo.self)
                .asObservable()
                
        )

        let output = viewModel.transform(from: input)
        
        output.searchResult
            .drive(questionListTableView.rx.items(
                cellIdentifier: CafeQuestionListCell.identifier,
                cellType: CafeQuestionListCell.self
            )
            )({ index, model, cell in
                cell.update(with: model)
            }).disposed(by: self.disposeBag)
        
        output.canLoad
            .emit(onNext: {
                [weak self] canLoad in
                    self?.isFetched = canLoad
            }).disposed(by: self.disposeBag)
        
        guard let coordinator = coordinator else { return }

        output.showCafeQuestionScene
            .emit(onNext: coordinator.showCafeQuestionScene(_:))
            .disposed(by: self.disposeBag)
    }
}

extension SearchCafeQuestionViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == questionListTableView else { return }
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

