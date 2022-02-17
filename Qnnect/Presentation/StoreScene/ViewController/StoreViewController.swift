//
//  StoreViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/16.
//

import UIKit
import SnapKit
import Then
import KakaoSDKCommon
import TTGTags
import RxSwift

enum IngredientType: CaseIterable,Codable {
    case iceOrBase
    case main
    case topping
    
    var title: String {
        switch self {
        case .iceOrBase:
            return "얼음ㆍ베이스"
        case .main:
            return "주 재료"
        case .topping:
            return "토핑"
        }
    }
}
// MARK: - 상점 Scene
final class StoreViewController: BaseViewController {
    
    private var viewModel: StoreViewModel!
    
    private let pointBar = PointBar()
    
    private let dummyData = [
        Ingredient(type: .iceOrBase, name: "얼음", price: 100),
        Ingredient(type: .iceOrBase, name: "얼음", price: 100),
        Ingredient(type: .iceOrBase, name: "물", price: 130),
        Ingredient(type: .iceOrBase, name: "카페인", price: 150),
        Ingredient(type: .iceOrBase, name: "얼음", price: 100),
        Ingredient(type: .iceOrBase, name: "카페인", price: 150),
        Ingredient(type: .iceOrBase, name: "얼음", price: 100),
        Ingredient(type: .iceOrBase, name: "물", price: 130),
        Ingredient(type: .iceOrBase, name: "우유", price: 110),
        Ingredient(type: .main, name: "녹차", price: 200),
        Ingredient(type: .main, name: "딸기", price: 300),
        Ingredient(type: .main, name: "초콜릿", price: 500),
        Ingredient(type: .main, name: "자몽", price: 400),
        Ingredient(type: .main, name: "토피넛", price: 150),
        Ingredient(type: .main, name: "히비스커스", price: 600),
        Ingredient(type: .main, name: "민트초코", price: 10),
        Ingredient(type: .topping, name: "휘핑크림", price: 100),
        Ingredient(type: .topping, name: "휘핑크림", price: 200),
        Ingredient(type: .topping, name: "휘핑크림", price: 300),
        Ingredient(type: .topping, name: "휘핑크림", price: 400),
        Ingredient(type: .topping, name: "휘핑크림", price: 500),
        Ingredient(type: .topping, name: "휘핑크림", price: 600)
        
    ]
    private let tagCollectionView = CustomTagCollectionView().then {
        $0.update(with: IngredientType.allCases.map { $0.title })
    }
    
    private let ingredientCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = .init(width: Constants.ingredientCellWidth, height: Constants.ingredientCellHeight)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 3.0, bottom: 0, right: 3.0)
        $0.collectionViewLayout = layout
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .p_ivory
        $0.register(IngredientCell.self, forCellWithReuseIdentifier: IngredientCell.identifier)
    }
    
    static func create(with viewModel: StoreViewModel) -> StoreViewController {
        let vc = StoreViewController()
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
            self.ingredientCollectionView
        ].forEach {
            self.view.addSubview($0)
        }
        
        self.view.backgroundColor = .p_ivory
        self.navigationController?.isNavigationBarHidden = true
        
        self.pointBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(Constants.pointBarHeight)
        }
        
        self.tagCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.tagCollectionViewHorizontalInset)
            make.top.equalTo(self.pointBar.snp.bottom).offset(Constants.tagBetweenPointBarSpace)
        }
        
        self.tagCollectionView.delegate = self
        self.tagCollectionView.updateTag(at: 0, selected: true)
        
        self.ingredientCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.tagCollectionView.snp.bottom).offset(25.0)
            make.leading.trailing.equalToSuperview().inset(17.0)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(20.0)
        }
        
    }
    
    override func bind() {
        
        //TODO: 테스트를위한 구독
        self.tagCollectionView.rx.tappedTagTitle
            .subscribe(onNext: { test in
                self.ingredientCollectionView.setContentOffset(.zero, animated: true)
                print("Tapped Tag title!!!",test)
            }).disposed(by: self.disposeBag)
        Observable.just(dummyData)
            .bind(to: self.ingredientCollectionView.rx.items(cellIdentifier: IngredientCell.identifier, cellType: IngredientCell.self)) { index, model, cell in
                cell.update(with: model)
            }.disposed(by: self.disposeBag)
        
        
    }
}

extension StoreViewController: TTGTextTagCollectionViewDelegate {
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
struct StoreViewController_Priviews: PreviewProvider {
    static var previews: some View {
        Contatiner().edgesIgnoringSafeArea(.all)
    }
    struct Contatiner: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            let vc = StoreViewController() //보고 싶은 뷰컨 객체
            return UINavigationController(rootViewController: vc)
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
        typealias UIViewControllerType =  UIViewController
    }
}
