//
//  CafeUseCase.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/06.
//

import Foundation
import RxSwift

protocol CafeUseCase: AnyObject {
    func fetchCafe(forId id: Int) -> Observable<Result<Cafe,Error>>
}

final class DefaultCafeUseCase: CafeUseCase {
    
    private let cafeRepository: CafeRepository
    
    init(cafeRepository: CafeRepository) {
        self.cafeRepository = cafeRepository
    }
    
    func fetchCafe(forId id: Int) -> Observable<Result<Cafe, Error>> {
        self.cafeRepository.fetchCafe(forId: id)
    }
}
