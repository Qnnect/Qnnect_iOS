//
//  OnBoardingViewController.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/23.
//

import UIKit

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
    
    static func create() -> OnboardingViewController {
        let vc = OnboardingViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
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
            make.centerY.equalToSuperview().multipliedBy(1.5)
        }
        
        self.startButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.bottomButtonHorizontalMargin)
            make.height.equalTo(0)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(24.0)
        }
    }
}

private extension OnboardingViewController {
    func makePageVC() {
        let vc1 = PageItemViewController()
        vc1.textLabel.text = "Test1"
        let vc2 = PageItemViewController()
        vc2.textLabel.text = "Test2"
        let vc3 = PageItemViewController()
        vc3.textLabel.text = "Test3"
        
        pages.append(vc1)
        pages.append(vc2)
        pages.append(vc3)
        
        setViewControllers([vc1], direction: .forward, animated: true, completion: nil) //  시작 page item 지정
        
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
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: [.curveEaseInOut],animations: {
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
            return pages.last
        }else{
            return pages[currentIndex - 1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        if currentIndex == pages.count - 1 {
            return pages.first
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
