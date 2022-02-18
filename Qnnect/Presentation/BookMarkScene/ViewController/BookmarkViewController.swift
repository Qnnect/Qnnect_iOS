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
    
    private let pointBar = PointBar()
    
    private let tagCollectionView = CustomTagCollectionView().then {
        $0.update(with: [
            "신사고 4인방",
            "스윗 마이홈",
            "아아메",
            "CMC IOS",
            "CMC 9기",
            "CMC 등산회"
        ])
    }
    
    private let bookmarkTableView = UITableView().then {
        $0.register(BookmarkCell.self, forCellReuseIdentifier: BookmarkCell.identifier)
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
        
        [
            self.pointBar,
            self.tagCollectionView,
            self.bookmarkTableView
        ].forEach {
            self.view.addSubview($0)
        }
        
        self.view.backgroundColor = .systemBackground
        self.navigationController?.isNavigationBarHidden = true
        self.pointBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(Constants.pointBarHeight)
        }
        
        self.tagCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.tagCollectionViewHorizontalInset)
            make.top.equalTo(self.pointBar.snp.bottom).offset(Constants.tagBetweenPointBarSpace)
        }
        
        self.tagCollectionView.delegate = self
        self.tagCollectionView.updateTag(at: 0, selected: true)
        
        self.bookmarkTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.top.equalTo(self.tagCollectionView.snp.bottom).offset(36.0)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(8.0)
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
    }
}

extension BookmarkViewController: TTGTextTagCollectionViewDelegate {
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTap tag: TTGTextTag!, at index: UInt) {
        let tags = textTagCollectionView?.allTags() ?? []
        tags.enumerated().forEach {
            if $0.element != tag, $0.element.selected {
                textTagCollectionView?.updateTag(at: UInt($0.offset), selected: false)
            }
        }
    }
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, canTap tag: TTGTextTag!, at index: UInt) -> Bool {
        return !tag.selected
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
