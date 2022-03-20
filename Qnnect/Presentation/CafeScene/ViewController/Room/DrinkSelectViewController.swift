//
//  SelectDrinkViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/23.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxDataSources

final class DrinkSelectViewController: BottomSheetViewController {
    
    private let mainLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .GRAY01
        $0.text = "완성할 음료를 선택해주세요"
    }
    
    private let secondaryLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 12.0)
        $0.textColor = .GRAY03
        $0.numberOfLines = 2
        let paragraphStyle = Constants.paragraphStyle
        paragraphStyle.alignment = .left
        $0.attributedText =
        NSAttributedString(
            string: "1인1음료를 선택하고 답변을 통해 얻은 \n 포인트로 나의 음료를 완성해보세요!",
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
    }
    
    private let drinksCollectionView = DrinkSelectCollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    ).then {
        $0.backgroundColor = .p_ivory
        $0.register(
            DrinkSelectCell.self,
            forCellWithReuseIdentifier: DrinkSelectCell.identifier
        )
        $0.register(
            PageControlFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: PageControlFooterView.identifier
        )
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let completionButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.backgroundColor = .p_brown
        $0.setTitleColor(.WHITE_FFFFFF, for: .normal)
        $0.layer.cornerRadius = Constants.bottomButtonCornerRadius
    }
    
    private var drinksCurPage = 0 {
        didSet {
            pageControl.currentPage = drinksCurPage
        }
    }
    
    private let pageControl = UIPageControl().then {
        $0.pageIndicatorTintColor = .GRAY04
        $0.currentPageIndicatorTintColor = .p_brown
    }
    
    private var viewModel: DrinkSelctViewModel!
    weak var coordinator: SelectDrinkCoordinator?
    private var cafeId: Int!
    
    static func create(
        with viewModel: DrinkSelctViewModel,
        _ cafeId: Int,
        _ coordinator: SelectDrinkCoordinator
    ) -> DrinkSelectViewController {
        let vc = DrinkSelectViewController()
        vc.viewModel = viewModel
        vc.cafeId = cafeId
        vc.coordinator = coordinator
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func configureUI() {
        
        [
            self.mainLabel,
            self.secondaryLabel,
            self.completionButton,
            drinksCollectionView,
            pageControl
        ].forEach {
            self.bottomSheetView.addSubview($0)
        }
        
        self.topPadding = 121.0
        
        self.titleLabel.text = "음료 선택"
        
        self.mainLabel.snp.makeConstraints { make in
            make.top.equalTo(self.dismissButton.snp.bottom).offset(16.0)
            make.leading.trailing.equalToSuperview().inset(Constants.bottomSheetHorizontalMargin)
        }
        
        self.secondaryLabel.snp.makeConstraints { make in
            make.top.equalTo(self.mainLabel.snp.bottom).offset(5.0)
            make.leading.trailing.equalTo(self.mainLabel)
        }
        
        
        drinksCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(secondaryLabel.snp.bottom)
        }
        
        drinksCollectionView.collectionViewLayout = createLayout()
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(drinksCollectionView.snp.bottom).offset(13.0)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(completionButton.snp.top).offset(-15.0)
        }
    
        self.completionButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(60.0)
            make.leading.trailing.equalToSuperview().inset(Constants.bottomSheetHorizontalMargin)
            make.height.equalTo(Constants.bottomButtonHeight)
        }
        
    }
    
    override func bind() {
        
        let input = DrinkSelctViewModel.Input(
            viewDidLoad: Observable.just(()),
            selectedDrink: drinksCollectionView.rx.modelSelected(Drink.self)
                .asObservable(),
            didTapCompletionButton: self.completionButton.rx.tap
                .asObservable(),
            cafeId: Observable.just(cafeId)
        )
        
        let output = self.viewModel.transform(from: input)
        let dataSource = self.createDataSource()
        
        output.drinks
            .map {
                [weak self] drinks -> [DrinkSelectSectionModel] in
                self?.pageControl.numberOfPages = drinks.count / 4 + 1
                return [DrinkSelectSectionModel(items: drinks),]
            }
            .debug()
            .drive(drinksCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        drinksCollectionView.rx.itemSelected
            .subscribe(onNext: {
                [weak self] indexPath in
                self?.changeDrinkSelectCellState(indexPath)
            }).disposed(by: self.disposeBag)
        
        guard let coordinator = coordinator else { return }

        output.completion
            .emit(onNext: coordinator.dismissDrinkSelectBottomSheet)
            .disposed(by: self.disposeBag)
    }
}

private extension DrinkSelectViewController {
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout {
            [weak self] section, environment -> NSCollectionLayoutSection? in
            switch section {
            case 0:
                return self?.createDrinksSectionLayout()
            default:
                return nil
            }
        }
    }
    
    func createDrinksSectionLayout() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        item.contentInsets = .init(top: 0, leading: 8.0, bottom: 0, trailing: 8.0)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        group.contentInsets = .init(top: 0, leading: 0, bottom: 16.0, trailing: 0)
        
        let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: nestedGroupSize,subitem: group,count: 2)
        
        nestedGroup.contentInsets = .init(top: 0, leading: 12.0, bottom: 0, trailing: 12.0)
        //section
        let section = NSCollectionLayoutSection(group: nestedGroup)
        section.visibleItemsInvalidationHandler = {
            items, contentOffset, environment in
            let point = contentOffset
            let env = environment
            self.drinksCurPage = Int(max(0, round(point.x / env.container.contentSize.width)))
        }
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.contentInsets = .init(top: 16.0, leading: 0, bottom: 0, trailing: 0)
        return section
    }
    
    
    func createDataSource() -> RxCollectionViewSectionedReloadDataSource<DrinkSelectSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<DrinkSelectSectionModel> { dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DrinkSelectCell.identifier,
                for: indexPath
            ) as! DrinkSelectCell
            cell.update(with: item)
            return cell
        }
    }
    
    //선택된 DrinkSelect Cell 선택 상태 변경
    func changeDrinkSelectCellState(_ indexPath: IndexPath) {
        let cell = drinksCollectionView.cellForItem(at: indexPath) as! DrinkSelectCell
        cell.isChecked.toggle()
        drinksCollectionView.lastSelectedCell?.isChecked.toggle()
        drinksCollectionView.lastSelectedCell = cell
    }
    
}


