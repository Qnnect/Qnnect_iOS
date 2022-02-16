//
//  TabbarItem.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/14.
//

import UIKit

enum TabbarItem: CaseIterable {
    case home
    case bookmark
    case store
    case myPage

    var title: String {
        switch self {
        case .home:
            return "홈"
        case .bookmark:
            return "북마크"
        case .store:
            return "상점"
        case .myPage:
            return "마이페이지"
        }
    }

    var icon: (default: UIImage?, selected: UIImage?) {
        switch self {
        case .home:
            return (UIImage(named: "home_default"),UIImage(named: "home_selected"))
        case .bookmark:
            return (UIImage(named: "bookmark_default"),UIImage(named: "bookmark_selected"))
        case .store:
            return (UIImage(named: "store_default"),UIImage(named: "store_selected"))
        case .myPage:
            return (UIImage(named: "mypage_default"),UIImage(named: "mypage_selected"))
        }

    }

    var coordinator: Coordinator {
        switch self {
        case .home:
            return DefaultHomeCoordinator(navigationController: UINavigationController())
        case .bookmark:
            return DefaultBookmarkCoordinator(navigationController: UINavigationController())
        case .store:
            return DefaultStoreCoordinator(navigationController: UINavigationController())
        case .myPage:
            return DefaultMyPageCoordinator(navigationController: UINavigationController())
        }
    }
}
