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
    
    private var viewModel: BookmarkViewModel!
    
    private let navigationTitleLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 18.0)
        $0.textColor = .BLACK_121212
        $0.text = "북마크"
    }
    
    private let headerView = UIView()
    
    private let tagCollectionView = CustomTagCollectionView().then {
        $0.addWholeTag()
        $0.update(with: [
            "신사고 4인방",
            "스윗 마이홈",
            "아아메",
            "CMC IOS",
            "CMC 9기",
            "CMC 등산회"
        ])
    }
    
    private let bookmarkTableView = UITableView(frame: .zero, style: .grouped).then {
        $0.register(BookmarkCell.self, forCellReuseIdentifier: BookmarkCell.identifier)
        $0.backgroundColor = .p_ivory
    }
    
    static func create(with viewModel: BookmarkViewModel) -> BookmarkViewController{
        let vc = BookmarkViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        
        self.view.addSubview(self.bookmarkTableView)
        self.view.backgroundColor = .p_ivory
        
        self.navigationItem.leftBarButtonItems = [
            Constants.navigationLeftPadding,
            UIBarButtonItem(customView: self.navigationTitleLabel)
        ]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Constants.notificationIcon, style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem?.tintColor = .BLACK_121212
        
        self.tagCollectionView.updateTag(at: 0, selected: true)
        
        self.bookmarkTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(17.0)
            make.top.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(8.0)
        }
        self.bookmarkTableView.sectionHeaderHeight = 60.0
        
        self.headerView.addSubview(self.tagCollectionView)
        
        self.tagCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
    }
    private let dummyData: [Bookmark] = [
        Bookmark(number: 1, title: "함께 가장 가고싶은 여행지는 어디인가요?", date: "22.12.22"),
        Bookmark(number: 2, title: "서로 해준 요리중에 가장 맛있었던 음식은 무엇인가...", date: "22.12.22"),
        Bookmark(number: 3, title: "가장 받고싶은 칭찬은 무엇인가요?", date: "22.12.22"),
        Bookmark(number: 4, title: "서로의 첫인상이 어땠나요?", date: "22.12.22")
    ]
    
    override func bind() {
        Observable.just(self.dummyData)
            .bind(to: self.bookmarkTableView.rx.items(cellIdentifier: BookmarkCell.identifier, cellType: BookmarkCell.self)) { index, model, cell in
                cell.update(with: model)
            }.disposed(by: self.disposeBag)
        
        self.bookmarkTableView.rx.setDelegate(self)
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


import SwiftUI
struct BookmarkViewController_Priviews: PreviewProvider {
    static var previews: some View {
        Contatiner().edgesIgnoringSafeArea(.all)
    }
    struct Contatiner: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            let vc = BookmarkViewController() //보고 싶은 뷰컨 객체
            return UINavigationController(rootViewController: vc)
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
        typealias UIViewControllerType =  UIViewController
    }
}
