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
            return Constants.emptyDrink
        case .base:
            return Constants.strawberryLatte_step_0
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
        $0.contentMode = .scaleAspectFit
    }
    
    private let progressBar = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = Constants.drinkProgressBar_step_0
    }
    
    private let stepLabelStackView = UIStackView().then {
        $0.distribution = .equalCentering
    }
    
    private let insertIngredientButton = UIButton().then {
        $0.setTitle("재료 넣기", for: .normal)
        $0.setTitleColor(.BLACK_121212, for: .normal)
        $0.backgroundColor = .p_ivory
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.secondaryBorder?.cgColor
        $0.layer.cornerRadius = 10.0
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
            stepLabelStackView
        ].forEach {
            view.addSubview($0)
        }
        
        var steps = DrinkStep.allCases
        steps.removeLast()
        steps.forEach { step in
            let label = UILabel().then {
                $0.font = .IM_Hyemin(.bold, size: 14.0)
                $0.textAlignment = .center
                $0.numberOfLines = 2
            }
            stepLabelStackView.addArrangedSubview(label)
        }

        
        userCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(90.0)
        }
        userCollectionView.collectionViewLayout = createLayout()
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(userCollectionView.snp.bottom).offset(34.0)
            make.leading.trailing.equalToSuperview().inset(33.0)
        }
        
        drinkImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(80.0)
            make.centerX.equalToSuperview()
        }
        
        progressBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(50.0)
            make.top.equalTo(drinkImageView.snp.bottom).offset(36.0)
        }
        
        stepLabelStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(progressBar)
            make.top.equalTo(progressBar.snp.bottom).offset(8.0)
        }
        
        insertIngredientButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.bottomButtonHorizontalMargin)
            make.height.equalTo(60.0)
            make.bottom.equalToSuperview().inset(60.0)
        }
        
        navigationItem.titleView = navigationTitleLabel
    }
    
    override func bind() {
        super.bind()
        
        userCollectionView.rx.methodInvoked(#selector(userCollectionView.reloadData))
            .subscribe(onNext: {
                [weak self] _ in
                guard let self = self else { return }
                let height = self.userCollectionView.collectionViewLayout.collectionViewContentSize.height
                self.userCollectionView.snp.updateConstraints { make in
                    make.height.equalTo(height)
                }
            }).disposed(by: self.disposeBag)
        
        let input = OurCafeViewModel.Input(
            cafeId: Observable.just(cafeId),
            cafeUserId: Observable.just(cafeUserId),
            viewWillAppear: rx.viewWillAppear.mapToVoid()
        )
        
        let output = viewModel.transform(from: input)
        
        output.userInfos
            .debug()
            .drive(userCollectionView.rx.items(
                cellIdentifier: OurCafeUserCell.identifier,
                cellType: OurCafeUserCell.self
            )
            )
        { index, model, cell in
            cell.update(with: model)
        }.disposed(by: self.disposeBag)
        
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
        
        let radio =  ((48.0 / 5.0) - 28.0) / UIScreen.main.bounds.width
        
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
}


private extension OurCafeViewController {
    func setCurStepLabelColor(_ curStep: DrinkStep) {
        guard curStep != .completed else { return }
        
        stepLabelStackView.subviews.enumerated().forEach { index, view in
            guard let label = view as? UILabel else { return }
            label.textColor = index == curStep.rawValue ? .ORANGE01 : .BLACK_121212
        }
    }
}
