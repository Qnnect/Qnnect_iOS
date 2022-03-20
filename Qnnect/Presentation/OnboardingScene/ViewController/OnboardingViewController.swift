//
//  OnBoardingViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/23.
//

import UIKit
import RxSwift
import SnapKit

enum OnboardingSceneType: CaseIterable {
    case question
    case connection
    case drink
    case stamp
    
    var mainTitle: String {
        switch self {
        case .question:
            return "나를 알아가는 질문"
        case .connection:
            return "가족/친구/커플간의\nQ&A 공유를 통한 소통"
        case .drink:
            return "나만의 음료 만들기"
        case .stamp:
            return "스탬프 - 내가 만든 음료 모아보기"
        }
    }
    
    var secondaryTitle: String {
        switch self {
        case .question:
            return "큐넥트 지킴이 넥트가\n여러분에게 단 하나의 질문을 드려요\nQ&A를 통해 나를 알아가고 일상을 회고해보세요!"
        case .connection:
            return "Q&A를 가족/친구/커플끼리 공유하여 서로에\n대해 알아가고 소통할 수 있어요!\n기본 제공 질문 외에 카페 멤버에게 하고싶은 질문을 직접 추가할 수도 있어요\n(큐넥트에서 카페란, 다이어리 그룹을 의미해요️)"
        case .drink:
            return "답변을 달거나 질문을 추가할수록 쌓이는\n원두 포인트를 통해\n나만의 음료를 만들어보세요"
        case .stamp:
            return "음료를 완성할 때마다 스탬프가 음료로 채워져요\n스탬프를 멋지게 채워보세요!"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .question:
            return Constants.onboardingImage1
        case .connection:
            return Constants.onboardingImage2
        case .drink:
            return Constants.onboardingImage3
        case .stamp:
            return Constants.onboardingImage4
        }
    }
    
}

final class OnboardingViewController: UIPageViewController{
    private var pages = [UIViewController]()
    private let pageControl = UIPageControl().then {
        $0.currentPageIndicatorTintColor = .black
        $0.pageIndicatorTintColor = .lightGray
    }
    private let startIndex = 0
    private var currentIndex = 0 {
        didSet {
            self.pageControl.currentPage = currentIndex
        }
    }
    
    private let startButton = UIButton().then {
        $0.backgroundColor = .p_brown
        $0.setTitle("시작하기", for: .normal)
        $0.setTitleColor(.WHITE_FFFFFF, for: .normal)
        $0.layer.cornerRadius = Constants.bottomButtonCornerRadius
    }
    
    private var viewModel: OnboardingViewModel!
    weak var coordinator: SplashCoordinator?
    private var inviteCode: String?
    
    private let disposeBag = DisposeBag()
    
    static func create(
        with viewModel: OnboardingViewModel,
        _ coordinator: SplashCoordinator,
        _ inviteCode: String?
    ) -> OnboardingViewController {
        let vc = OnboardingViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        vc.coordinator = coordinator
        vc.viewModel = viewModel
        vc.inviteCode = inviteCode
        return vc
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        makePageVC()
        
        [
            self.pageControl,
            self.startButton
        ].forEach {
            self.view.addSubview($0)
        }
        
        
        self.pageControl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.top.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.startButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.bottomButtonHorizontalMargin)
            make.height.equalTo(0)
            make.bottom.equalToSuperview().inset(58.0)
        }
        
        self.bind()
    }
}

private extension OnboardingViewController {
    
    func bind() {
        
        let input = OnboardingViewModel.Input(
            didTapStartButton: self.startButton.rx.tap.mapToVoid(),
            inviteCode: Observable.just(inviteCode).compactMap{ $0 }
        )
        
        let output = self.viewModel.transform(from: input)
        
        guard let coordinator = coordinator else { return }
        output.showLoingScene
            .emit(onNext: {
                [weak self] _ in
                self?.coordinator?.showLogin()
            })
            .disposed(by: self.disposeBag)
        
        output.inviteFlowLoginScene
            .emit(onNext: coordinator.showLogin(_:))
            .disposed(by: self.disposeBag)
        
    }
    func makePageVC() {
        OnboardingSceneType.allCases.forEach { type in
            let vc = PageItemViewController.create(with: type)
            pages.append(vc)
        }
        
        
        setViewControllers([pages.first ?? UIViewController()], direction: .forward, animated: true, completion: nil) //  시작 page item 지정
        
        self.pageControl.numberOfPages = pages.count
        self.pageControl.currentPage = startIndex
        self.pageControl.addTarget(self, action: #selector(pageControlTapped), for: .valueChanged)
        
        self.delegate = self
        self.dataSource = self
    }
    
    @objc func pageControlTapped(sender : UIPageControl){
        
        if sender.currentPage > self.currentIndex{
            setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true, completion: nil)
        }else{
        setViewControllers([pages[sender.currentPage]], direction: .reverse, animated: true, completion: nil)
        }
        //delegate의 메소드는 제스처 기반 탐색 및 방향 변경에 따라 호출됩니다.
        //따라서 pageControl을 클릭하여 setViewControllers 메소드로 화면전환시에는 delegate가 호출하지 않는다.
        self.currentIndex = sender.currentPage
        buttonPresentationStyle()
        
    }
    func buttonPresentationStyle(){
        if currentIndex == pages.count - 1 {
            //show button
            showButton()
        }else{
            //hide button
            hideButton()
        }
        //        UIView.animate(withDuration: 0.5) {
        //            self.view.layoutIfNeeded()
        //        }
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [.curveEaseInOut],animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    func showButton(){
        self.startButton.snp.updateConstraints { make in
            make.height.equalTo(Constants.bottomButtonHeight)
        }
    }
    func hideButton(){
        self.startButton.snp.updateConstraints { make in
            make.height.equalTo(0)
        }
    }
}

extension OnboardingViewController : UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        if currentIndex == startIndex {
            return nil
        }else{
            return pages[currentIndex - 1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        if currentIndex == pages.count - 1 {
            return nil
        }else{
            return pages[currentIndex + 1]
        }
    }
}


extension OnboardingViewController : UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let currentVC = pageViewController.viewControllers?.first else { return }
        guard let currentIndex = pages.firstIndex(of: currentVC) else { return }
        
        self.currentIndex = currentIndex
        buttonPresentationStyle()
        
    }
}

import SwiftUI
struct OnboardingViewController_Priviews: PreviewProvider {
    static var previews: some View {
        Contatiner().edgesIgnoringSafeArea(.all)
    }
    struct Contatiner: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            let vc = OnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
        typealias UIViewControllerType =  UIViewController
    }
}
