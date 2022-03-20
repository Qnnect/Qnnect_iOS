//
//  CafeDrinksViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/17.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxDataSources

enum DrinkStep: Int, CaseIterable {
    case ice = 0
    case base = 1
    case main = 2
    case topping = 3
    case completed = 4
    
    var title: String {
        switch self {
        case .ice:
            return "얼음"
        case .base:
            return "베이스"
        case .main:
            return "주재료"
        case .topping:
            return "토핑"
        case .completed:
            return "완성"
        }
    }
    
    var progressBarImage: UIImage? {
        switch self {
        case .ice:
            return Constants.drinkProgressBar_step_0
        case .base:
            return Constants.drinkProgressBar_step_1
        case .main:
            return Constants.drinkProgressBar_step_2
        case .topping:
            return Constants.drinkProgressBar_step_3
        case .completed:
            return Constants.drinkProgressBar_step_3
        }
    }
    
    var drinkImage: UIImage? {
        switch self {
        case .ice:
            return Constants.drinkEmptyImage
        case .base:
            return Constants.drinkIceStepImage
        case .main:
            return Constants.strawberryLatte_step_1
        case .topping:
            return Constants.strawberryLatte_step_2
        case .completed:
            return Constants.strawberryLatte_step_3
        }
    }
    
}

final class OurCafeViewController: BaseViewController {
    
    private let navigationTitleLabel = NavigationTitleLabel(title: "우리의 음료")
    
    private let userCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    ).then{
        $0.register(OurCafeUserCell.self, forCellWithReuseIdentifier: OurCafeUserCell.identifier)
        $0.backgroundColor = .p_ivory
        $0.isScrollEnabled = false
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 18.0)
        $0.textColor = .black
        $0.text = "내 음료"
    }
    
    private let drinkImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let progressBar = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = Constants.drinkProgressBar_step_0
    }
    
    private let stepLabelStackView = UIStackView().then {
        $0.distribution = .equalCentering
    }
    
    private let insertIngredientButton = UIButton().then {
        $0.setTitle("재료 넣기", for: .normal)
        $0.setTitleColor(.BLACK_121212, for: .normal)
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 16.0)
        $0.backgroundColor = .p_ivory
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.secondaryBorder?.cgColor
        $0.layer.cornerRadius = 10.0
    }
    
    // 음료를 선택하지 않은 유저 일 경우 보이는 라벨
    private let notSelectLabel = UILabel().then {
        $0.font = .IM_Hyemin(.bold, size: 16.0)
        $0.textColor = .BLACK_121212
        $0.isHidden = true
        $0.numberOfLines = 2
        let paragraphStyle = Constants.paragraphStyle
        paragraphStyle.alignment = .center
        $0.attributedText = NSMutableAttributedString(
            string: "지민님은 아직\n음료를 고르지 않았어요.",
            attributes: [NSMutableAttributedString.Key.paragraphStyle: paragraphStyle]
        )
    }
    
    /// 자신이 음료를 선택하지 않았을 경우 나오는 버튼
    private let selectDrinkButton = UIButton().then {
        $0.setTitle("음료 고르기", for: .normal)
        $0.setTitleColor(.BLACK_121212, for: .normal)
        $0.titleLabel?.font = .IM_Hyemin(.bold, size: 16.0)
        $0.backgroundColor = .p_ivory
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.secondaryBorder?.cgColor
        $0.layer.cornerRadius = 10.0
        $0.isHidden = true
    }
    
    private var viewModel: OurCafeViewModel!
    weak var coordinator: OurCafeCoordinator?
    private var cafeId: Int!
    private var cafeUserId: Int!
    
    static func create(
        with viewModel: OurCafeViewModel!,
        _ coordinator: OurCafeCoordinator,
        cafeId: Int,
        cafeUserId: Int
    ) -> OurCafeViewController {
        let vc = OurCafeViewController()
        vc.viewModel = viewModel
        vc.coordinator = coordinator
        vc.cafeId = cafeId
        vc.cafeUserId = cafeUserId
        return vc
    }
    
    private let radio =  ((48.0 / 5.0) - 28.0) / UIScreen.main.bounds.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func configureUI() {
        super.configureUI()
        
        [
            userCollectionView,
            titleLabel,
            drinkImageView,
            progressBar,
            insertIngredientButton,
            stepLabelStackView,
            notSelectLabel,
            selectDrinkButton
        ].forEach {
            view.addSubview($0)
        }
        
        var steps = DrinkStep.allCases
        steps.removeLast()
        steps.forEach { step in
            let label = UILabel().then {
                $0.font = .BM_JUA(size: 14.0)
                $0.textAlignment = .center
                $0.numberOfLines = 2
            }
            stepLabelStackView.addArrangedSubview(label)
        }

        
        userCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo((UIScreen.main.bounds.width / 5.0) + 32.0 + 26.0)
            
        }
        userCollectionView.collectionViewLayout = createLayout()
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(userCollectionView.snp.bottom).offset(34.0)
            make.leading.trailing.equalToSuperview().inset(33.0)
        }
        
        drinkImageView.snp.makeConstraints { make in
            make.bottom.equalTo(progressBar.snp.top).offset(-30.0)
            make.leading.trailing.equalToSuperview().inset(130.0)
        }
        
        progressBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(50.0)
            make.bottom.equalTo(stepLabelStackView.snp.top).offset(-8.0)
        }
        
        stepLabelStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(45.0)
            make.bottom.equalTo(insertIngredientButton.snp.top).offset(-78.0)
        }
        
        insertIngredientButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.bottomButtonHorizontalMargin)
            make.height.equalTo(60.0)
            make.bottom.equalToSuperview().inset(60.0)
        }
        
        notSelectLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(211.0)
            make.centerX.equalToSuperview()
        }
        
        selectDrinkButton.snp.makeConstraints { make in
            make.edges.equalTo(insertIngredientButton)
        }
        
        
        navigationItem.titleView = navigationTitleLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: Constants.navi_store,
            style: .plain,
            target: self,
            action: #selector(didTapStoreButton)
        )
    }
    
    override func bind() {
        super.bind()
        
        let input = OurCafeViewModel.Input(
            cafeId: Observable.just(cafeId),
            cafeUserId: Observable.just(cafeUserId),
            viewDidLoad: Observable.just(()),
            viewWillAppear: rx.viewWillAppear.mapToVoid(),
            didTapOurCafeUserCell: userCollectionView.rx.modelSelected(OurCafeUser.self)
                .do {
                    [weak self] user in
                    guard let self = self else { return }
                    user.cafeUserId == self.cafeUserId ? self.setTitleLabel(true, user.nickName) : self.setTitleLabel(false, user.nickName)
                }
                .asObservable()
                ,
            didTapInsertIngredientButton: insertIngredientButton.rx.tap.asObservable(),
            didTapStoreButton: rx.methodInvoked(#selector(didTapStoreButton)).mapToVoid()
        )
        
        let output = viewModel.transform(from: input)
        
        output.userInfos
            .debug()
            .map {
                userInfos -> [UserSelectSectionModel] in
                return [ UserSelectSectionModel.init(items: userInfos) ]
            }
            .drive(userCollectionView.rx.items(dataSource: createDataSource()))
            .disposed(by: self.disposeBag)
        
        userCollectionView.rx.methodInvoked(#selector(userCollectionView.reloadData))
            .skip(1)
            .subscribe(onNext: {
                [weak self] _ in
                self?.userCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)
                
            }).disposed(by: self.disposeBag)
        
        output.curStep
            .debug()
            .drive(onNext: {
                [weak self] curStep in
                self?.progressBar.image = curStep.progressBarImage
                self?.drinkImageView.image = curStep.drinkImage
                self?.setCurStepLabelColor(curStep)
            }).disposed(by: self.disposeBag)
        
        output.drinkState
            .debug()
            .drive(onNext: {
                [weak self] drinkState in
                self?.stepLabelStackView.subviews.enumerated().forEach({
                    index, view in
                    guard let label = view as? UILabel else { return }
                    label.text = """
                                \(DrinkStep(rawValue: index)?.title ?? "")
                                \(drinkState[index].filled)/\(drinkState[index].target)
                                """
                })
            }).disposed(by: self.disposeBag)
        
        output.isUserDrinkFetched
            .emit(onNext: setBottomLayout(_:))
            .disposed(by: self.disposeBag)
        
        guard let coordinator = coordinator else { return }

        output.showInsertIngredientScene
            .emit(onNext: coordinator.showInsertIngredientScene(_:))
            .disposed(by: self.disposeBag)
        
        output.showStoreScene
            .emit(onNext: coordinator.showStoreScene)
            .disposed(by: self.disposeBag)
        
    }
}

private extension OurCafeViewController {
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout {
            [weak self] section, environment -> NSCollectionLayoutSection? in
            switch section {
            case 0:
                return self?.ourCafeUserSection()
            default:
                return nil
            }
        }
    }
    
    func ourCafeUserSection() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        //item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
         
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.2 - radio))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 5)
        group.contentInsets = .init(top: 0, leading: 21.0, bottom: 0, trailing: 0)
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(12.0)
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 26.0, leading: 0, bottom: 0, trailing: 0)
        
        return section
    }
    
    func createDataSource() -> RxCollectionViewSectionedReloadDataSource<UserSelectSectionModel> {
        return  RxCollectionViewSectionedReloadDataSource<UserSelectSectionModel> {
            dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: OurCafeUserCell.identifier,
                for: indexPath
            ) as? OurCafeUserCell else { return UICollectionViewCell() }
            cell.update(with: item)
            return cell
        }
    }
}


private extension OurCafeViewController {
    func setCurStepLabelColor(_ curStep: DrinkStep) {
        guard curStep != .completed else { return }
        
        stepLabelStackView.subviews.enumerated().forEach { index, view in
            guard let label = view as? UILabel else { return }
            label.textColor = index == curStep.rawValue ? .ORANGE01 : .BLACK_121212
        }
    }
    
    @objc dynamic func didTapStoreButton() { }
    
    func setBottomLayout(_ isUserDrinkFetched: Bool) {
        if !isUserDrinkFetched {
            insertIngredientButton.isHidden = true
            progressBar.isHidden = true
            stepLabelStackView.isHidden = true
            drinkImageView.image = Constants.drinkEmptyImage
            notSelectLabel.isHidden = false
            
            if let indexPath = userCollectionView.indexPathsForSelectedItems?.first, indexPath.row == 0 {
                selectDrinkButton.isHidden = false
            }
        } else {
            progressBar.isHidden = false
            stepLabelStackView.isHidden = false
            notSelectLabel.isHidden = true
            selectDrinkButton.isHidden = true
        }
    }
    
    func setTitleLabel(_ isCurrentUser: Bool, _ name: String) {
        insertIngredientButton.isHidden = !isCurrentUser
        titleLabel.text = isCurrentUser ? "내 음료" : "\(name) 음료"
    }

}


extension OurCafeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: OurCafeUserCell.identifier,
            for: indexPath
        ) as? OurCafeUserCell else { return }
        if indexPath.item == 0 {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
        } else {
            cell.isSelected = false
        }
    }
}