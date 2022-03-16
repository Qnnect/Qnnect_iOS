//
//  BookmarkSearchViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/15.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class BookmarkSearchViewController: BaseViewController {
    
    private let searchBar = UISearchBar().then {
        $0.placeholder = "질문리스트에서 검색"
        $0.searchTextField.font = .IM_Hyemin(.bold, size: 14.0)
    }
    
    private let resultTableView = UITableView(frame: .zero, style: .grouped).then {
        $0.register(BookmarkCell.self, forCellReuseIdentifier: BookmarkCell.identifier)
        $0.backgroundColor = .p_ivory
        $0.showsVerticalScrollIndicator = false
        $0.contentInset = .zero
        $0.sectionHeaderHeight = 1
        $0.separatorInsetReference = .fromCellEdges
        $0.separatorInset = .init(top: 0, left: 23.0, bottom: 0, right: 23.0)
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.tableFooterView = UIView(frame: .zero)
        $0.sectionFooterHeight = 0
    }
    
    private var curPage = 0
    private var isFetched = true
    
    private var viewModel: BookmarkSearchViewModel!
    weak var coordinator: BookmarkCoordinator?
    
    static func create(
        with viewModel: BookmarkSearchViewModel,
        _ coordinator: BookmarkCoordinator
    ) -> BookmarkSearchViewController {
        let vc = BookmarkSearchViewController()
        vc.viewModel = viewModel
        vc.coordinator = coordinator
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        view.addSubview(resultTableView)
        navigationItem.titleView = searchBar
        
        resultTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        resultTableView.delegate = self
        
    }
    
    override func bind() {
        super.bind()
        
        let input = BookmarkSearchViewModel.Input(
            searchWord: searchBar.rx.text.orEmpty
                .filter { $0.count > 0 }
                .do {
                    [weak self] _ in
                    self?.curPage = 0
                }
                .asObservable(),
            moreFetch: self.rx.methodInvoked(#selector(fetchMore))
                .map{ $0[0] as! Int},
            didTapQuestion: resultTableView.rx.modelSelected(QuestionShortInfo.self)
                .map { $0.cafeQuestionId }
        )

        let output = viewModel.transform(from: input)
        
        output.searchResult
            .drive(resultTableView.rx.items(
                cellIdentifier: BookmarkCell.identifier,
                cellType: BookmarkCell.self
            )
            )({ index, model, cell in
                cell.update(with: model)
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
    }
}

extension BookmarkSearchViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == resultTableView else { return }
        
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

extension BookmarkSearchViewController: UITableViewDelegate {
    // section 의 separator 지우는 기능
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let border = CALayer()
        border.backgroundColor = tableView.backgroundColor?.cgColor
        border.frame = CGRect(x: 0, y: view.frame.size.height, width: view.frame.size.width, height: 1)
        view.layer.addSublayer(border)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UIView()
    }
    
}
