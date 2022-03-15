//
//  Coordinator.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/10.
//


import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get }
    var parentCoordinator: Coordinator? { get set }
    
    func start()
    
    // ✅ child coordinator 배열에서 지워야 할 coordinator 를 찾아서 제거하는 메서드
    func childDidFinish(_ child: Coordinator?)
    
}

extension Coordinator {
    // ✅ child coordinator 배열에서 지워야 할 coordinator 를 찾아서 제거하는 메서드
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            
            // ✅ === 연산자는 클래스의 두 인스턴스가 동일한 메모리를 가리키는지에 대한 연산(그래서 === 연산자를 사용하기 위해서 Coordinator 를 클레스 전용 프로토콜(class-only protocol) 로 만들어준다.)
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
